import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({
    super.key,
    required this.boardCode,
    required this.onLeaveBoard,
    required this.numScores,
    required this.incrementVal,
    required this.onResetScores,
    required this.onSetNumScores,
    required this.onSetIncrementVal,
  });

  final String boardCode;
  final int numScores;
  final int incrementVal;
  final void Function() onResetScores;
  final void Function() onLeaveBoard;
  final void Function(int n) onSetNumScores;
  final void Function(int val) onSetIncrementVal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(boardCode, style: const TextStyle(color: Colors.white)),
            TextButton(
              onPressed: onLeaveBoard,
              child: const Text(
                'Leave Board',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
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
              onPressed:
                  numScores <= 1 ? null : () => onSetNumScores(numScores - 1),
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            Text(
              "$numScores score card${numScores != 1 ? 's' : ''}",
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
                onPressed: () => onSetNumScores(numScores + 1),
                icon: const Icon(Icons.add, color: Colors.white)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () =>
                  onSetIncrementVal(incrementVal == 1 ? -1 : incrementVal - 1),
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            Text(
              incrementVal > 0 ? '+$incrementVal' : '$incrementVal',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
                onPressed: () => onSetIncrementVal(
                    incrementVal == -1 ? 1 : incrementVal + 1),
                icon: const Icon(Icons.add, color: Colors.white)),
          ],
        ),
      ],
    );
  }
}
