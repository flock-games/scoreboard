import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    super.key,
    required this.numPlayers,
    required this.incrementVal,
    required this.onResetScores,
    required this.onSetNumPlayers,
    required this.onSetIncrementVal,
  });

  final int numPlayers;
  final int incrementVal;
  final void Function() onResetScores;
  final void Function(int n) onSetNumPlayers;
  final void Function(int val) onSetIncrementVal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: onResetScores,
          child: const Text(
            'Reset Scores',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: numPlayers <= 1
                  ? null
                  : () => onSetNumPlayers(numPlayers - 1),
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            const Text(
              "# players",
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
                onPressed: () => onSetNumPlayers(numPlayers + 1),
                icon: const Icon(Icons.add, color: Colors.white)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => onSetIncrementVal(incrementVal - 1),
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            Text(
              incrementVal > 0 ? '+$incrementVal' : '$incrementVal',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
                onPressed: () => onSetIncrementVal(incrementVal + 1),
                icon: const Icon(Icons.add, color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
