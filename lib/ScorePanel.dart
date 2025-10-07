import 'package:flutter/material.dart';

class ScorePanel extends StatelessWidget {
  final Color _panelColor;
  final Color _textColor;
  final int score;
  final VoidCallback onIncrementScore;

  const ScorePanel({
    super.key,
    required Color panelColor,
    required Color textColor,
    required this.score,
    required this.onIncrementScore,
  })  : _panelColor = panelColor,
        _textColor = textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onIncrementScore,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: _panelColor,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Center(
            child: Text(
              '$score',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: _textColor, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
