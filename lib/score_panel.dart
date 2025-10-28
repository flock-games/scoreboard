import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScorePanel extends StatelessWidget {
  final Color _panelColor;
  final Color _textColor;
  final int score;
  final VoidCallback onIncrementScore;
  final VoidCallback onDecrementScore;

  const ScorePanel({
    super.key,
    required Color panelColor,
    required Color textColor,
    required this.score,
    required this.onIncrementScore,
    required this.onDecrementScore,
  })  : _panelColor = panelColor,
        _textColor = textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _panelColor,
      child: Stack(
        children: [
          // Score display taking up full space
          SizedBox.expand(
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
          // Invisible gesture zones overlaid on top
          Column(
            children: [
              // Top half - increment zone
              Expanded(
                child: GestureDetector(
                  onTap: onIncrementScore,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: double.infinity,
                  ),
                ),
              ),
              // Bottom half - decrement zone
              Expanded(
                child: GestureDetector(
                  onTap: onDecrementScore,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
