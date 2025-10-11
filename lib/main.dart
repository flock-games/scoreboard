import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:starter/ScorePanel.dart';
import 'package:starter/SettingsPanel.dart';
import 'package:starter/models/Player.dart';

void main() {
  runApp(const ScoreboardApp());
}

class ScoreboardApp extends StatelessWidget {
  const ScoreboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoreboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomePage(title: 'Scoreboard'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Player> players = [];
  int numPlayers = 2;
  int incrementVal = 1;
  bool showingSettings = false;
  String? boardId;

  // TODO: move into config file
  final projectId = "68e17c8e00373d10eb32";
  final dbId = "68e71a5f0012ae225c4e";
  RealtimeSubscription? scoresSubscription;
  late final Client client;
  late final TablesDB databases;

  @override
  void initState() {
    super.initState();
    client = Client()
        .setProject(projectId)
        .setEndpoint('https://sfo.cloud.appwrite.io/v1');
    databases = TablesDB(client);
    subscribeToScores();
  }

  void subscribeToScores() {
    final realtime = Realtime(client);
    scoresSubscription =
        realtime.subscribe(['databases.$dbId.tables.scores.rows']);

    scoresSubscription?.stream.listen((event) {
      // Find player score update belongs to, or create new player if not found.
      final payload = event.payload;
      final player = players.firstWhere((p) => p.dbId == payload['\$id'],
          orElse: () => Player(
                dbId: payload['\$id'],
                name: payload['name'],
                score: 0,
                bgColor: Color(int.parse(payload['bgColor'])),
                textColor: Color(int.parse(payload['textColor'])),
              ));

      // Update their local score.
      setState(() {
        player.score = payload['score'];
        if (!players.contains(player)) {
          players.add(player);
        }
      });
    });
  }

  void resetScores() {
    setState(() {
      for (var player in players) {
        updateScore(player, 0);
      }
    });
  }

  void setNumPlayers(int n) async {
    // If this introduces a new player, create a record.
    print('setNumPlayers $n');
    if (n > players.length) {
      print('lets create a new player');
      final res = await databases.createRow(
          databaseId: dbId,
          tableId: 'scores',
          rowId: ID.unique(),
          data: {
            'boardId': boardId,
            'name': 'Player ${players.length + 1}',
            'score': 0,
            'bgColor': '0xff000000',
            'textColor': '0xffffffff',
          });
      print(res);
      // setState(() {
      //   players.add(newPlayer);
      // });
    } else if (n < players.length) {
      // If removing a player, just remove from local state for now.
      setState(() {
        players = players.sublist(0, n);
      });
    }
  }

  void setIncrementVal(int val) {
    setState(() {
      incrementVal = val;
    });
  }

  void loadScoreboard(String boardCode) async {
    try {
      final boards = await databases.listRows(
          databaseId: dbId,
          tableId: 'boards',
          queries: [Query.equal('code', 'abcd')]);
      if (boards.rows.isEmpty) {
        print('No matching boards found');
        return;
      }

      boardId = boards.rows[0].$id;

      // widget.client.sub
      final scores = await databases.listRows(
          databaseId: dbId,
          tableId: 'scores',
          queries: [Query.equal('boardId', boardId)]);
      if (scores.rows.isEmpty) {
        print('No scores found for board');
        return;
      }
      players.clear();
      for (var score in scores.rows) {
        setState(() {
          players.add(Player(
            dbId: score.$id,
            name: score.data['name'],
            score: score.data['score'],
            bgColor: Color(int.parse(score.data['bgColor'])),
            textColor: Color(int.parse(score.data['textColor'])),
          ));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void updateScore(Player player, int newScore) async {
    setState(() {
      player.score = newScore;
    });

    if (player.dbId == null) return;
    try {
      await databases.updateRow(
        databaseId: dbId,
        tableId: 'scores',
        rowId: player.dbId!,
        data: {
          'score': newScore,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> scorePanels = <Widget>[];
    for (Player player in players) {
      scorePanels.add(
        Expanded(
          child: ScorePanel(
            score: player.score,
            panelColor: player.bgColor,
            textColor: player.textColor,
            onIncrementScore: () =>
                updateScore(player, player.score + incrementVal),
          ),
        ),
      );
    }

    final settingsIconButton = IconButton(
      icon: const Icon(Icons.settings, color: Colors.white),
      onPressed: () {
        setState(() {
          showingSettings = !showingSettings;
        });
      },
      padding: const EdgeInsets.all(16),
      iconSize: 32,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
    );

    final settingsPanel = Container(
      color: Colors.black,
      child: SettingsPanel(
        numPlayers: players.length,
        incrementVal: incrementVal,
        onResetScores: resetScores,
        onSetNumPlayers: setNumPlayers,
        onSetIncrementVal: setIncrementVal,
        onLoadBoard: loadScoreboard,
      ),
    );

    return Material(
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: scorePanels,
              ),
              settingsIconButton,
              if (showingSettings)
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: settingsPanel,
                )
            ],
          );
        }
        return Stack(
          alignment: Alignment.centerRight,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: scorePanels,
            ),
            settingsIconButton,
            if (showingSettings)
              Positioned(right: 60, top: 0, bottom: 0, child: settingsPanel)
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    scoresSubscription?.close();
    super.dispose();
  }
}
