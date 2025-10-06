import 'package:flutter/material.dart';
import 'package:starter/ScorePanel.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        const scorePanels = [
          Expanded(
            child: ScorePanel(
              panelColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
          Expanded(
            child: ScorePanel(
              panelColor: Colors.red,
              textColor: Colors.white,
            ),
          ),
        ];
        if (orientation == Orientation.landscape) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: scorePanels,
          );
        }
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: scorePanels,
        );
      }),
    );
  }
}
