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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scoreboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Player> players = [
    Player(
        name: 'Player 1',
        score: 0,
        bgColor: Colors.primaries[0],
        textColor: Colors.white),
  ];
  int numPlayers = 2;
  bool showingSettings = false;

  void resetScores() {
    setState(() {
      for (var player in players) {
        player.score = 0;
      }
    });
  }

  void setNumPlayers(int n) {
    setState(() {
      players.clear();
      for (int i = 0; i < n; i++) {
        players.add(Player(
          name: 'Player ${i + 1}',
          score: 0,
          bgColor: Colors.primaries[i % Colors.primaries.length],
          textColor: Colors.white,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        List<Widget> scorePanels = <Widget>[];

        for (Player player in players) {
          scorePanels.add(
            Expanded(
              child: ScorePanel(
                score: player.score,
                panelColor: player.bgColor,
                textColor: player.textColor,
                onIncrementScore: () => {
                  setState(() {
                    player.score++;
                  })
                },
              ),
            ),
          );
        }

        if (orientation == Orientation.landscape) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: scorePanels,
              ),
              IconButton(
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
              ),
              if (showingSettings)
                Positioned(
                  bottom: 60,
                  child: Container(
                    color: Colors.black,
                    child: SettingsPanel(
                      numPlayers: players.length,
                      onResetScores: resetScores,
                      onSetNumPlayers: setNumPlayers,
                    ),
                  ),
                ),
            ],
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: scorePanels,
        );
      }),
    );
  }
}
