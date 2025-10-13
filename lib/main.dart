import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:scoreboard/board_selector.dart';
import 'package:scoreboard/models/Board.dart';
import 'package:scoreboard/score_panel.dart';
import 'package:scoreboard/settings_panel.dart';
import 'package:scoreboard/models/player.dart';

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
      home: const HomePage(title: 'Scoreboard'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Player> players = [];
  int numPlayers = 2;
  int incrementVal = 1;
  bool showingSettings = false;
  Board? board;

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

    scoresSubscription?.stream.listen((data) {
      // Find player score update belongs to, or create new player if not found.
      final event = data.events.first;
      final payload = data.payload;
      final player = players.firstWhere((p) => p.dbId == payload['\$id'],
          orElse: () => Player(
                dbId: payload['\$id'],
                name: payload['name'],
                score: 0,
                bgColor: Color(int.parse(payload['bgColor'])),
                textColor: Color(int.parse(payload['textColor'])),
              ));

      // Update local state to match.
      setState(() {
        if (event.endsWith('.delete')) {
          players.remove(player);
          return;
        } else {
          player.score = payload['score'];
          if (!players.contains(player)) {
            players.add(player);
          }
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
    if (n > players.length) {
      // This introduces a new player; create a record.
      await databases.createRow(
          databaseId: dbId,
          tableId: 'scores',
          rowId: ID.unique(),
          data: {
            'boardId': board!.id,
            'name': 'Player ${players.length + 1}',
            'score': 0,
            'bgColor': '0xff000000',
            'textColor': '0xffffffff',
          });
    } else if (n < players.length) {
      // This removes a player; delete their record.
      await databases.deleteRow(
          databaseId: dbId, tableId: 'scores', rowId: players[n].dbId!);
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
          queries: [Query.equal('code', boardCode)]);
      if (boards.rows.isEmpty) {
        print('No matching boards found');
        return;
      }

      setState(() {
        board = Board(id: boards.rows[0].$id, code: boardCode);
      });

      final scores = await databases.listRows(
          databaseId: dbId,
          tableId: 'scores',
          queries: [Query.equal('boardId', board!.id)]);

      setState(() {
        players.clear();
      });
      if (scores.rows.isEmpty) {
        print('No scores found for board');
        return;
      }
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

  void createNewBoard() async {
    final id = ID.unique();
    final code = ID.unique().substring(0, 4).toUpperCase();
    await databases
        .createRow(databaseId: dbId, tableId: 'boards', rowId: id, data: {
      'code': code,
    });
    loadScoreboard(code);
  }

  void leaveBoard() {
    setState(() {
      board = null;
      players.clear();
      showingSettings = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (board == null) {
      return BoardSelector(
          onLoadBoard: loadScoreboard, onNewBoard: createNewBoard);
    }
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
        boardCode: board!.code,
        numPlayers: players.length,
        incrementVal: incrementVal,
        onResetScores: resetScores,
        onSetNumPlayers: setNumPlayers,
        onSetIncrementVal: setIncrementVal,
        onLeaveBoard: leaveBoard,
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
