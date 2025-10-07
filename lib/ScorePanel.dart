import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          child: Text(
            '$score',
            style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
                color: _textColor,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
