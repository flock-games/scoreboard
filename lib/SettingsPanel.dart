import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    super.key,
    required this.numPlayers,
    required this.onResetScores,
    required this.onSetNumPlayers,
  });

  final int numPlayers;
  final void Function() onResetScores;
  final void Function(int n) onSetNumPlayers;

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
      ],
    );
  }
}
