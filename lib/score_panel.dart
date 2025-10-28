import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScorePanel extends StatefulWidget {
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
  State<ScorePanel> createState() => _ScorePanelState();
}

class _ScorePanelState extends State<ScorePanel> with TickerProviderStateMixin {
  late AnimationController _topAnimationController;
  late AnimationController _bottomAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _topAnimation;
  late Animation<double> _bottomAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _topAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bottomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _topAnimation = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(parent: _topAnimationController, curve: Curves.easeOut),
    );
    _bottomAnimation = Tween<double>(begin: 0.0, end: 0.3).animate(
      CurvedAnimation(
          parent: _bottomAnimationController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _topAnimationController.dispose();
    _bottomAnimationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ScorePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _scaleAnimationController.forward().then((_) {
        _scaleAnimationController.reverse();
      });
    }
  }

  void _handleTopTap() {
    widget.onIncrementScore();
    _topAnimationController.forward().then((_) {
      _topAnimationController.reverse();
    });
  }

  void _handleBottomTap() {
    widget.onDecrementScore();
    _bottomAnimationController.forward().then((_) {
      _bottomAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget._panelColor,
      child: Stack(
        children: [
          // Score display taking up full space
          SizedBox.expand(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '${widget.score}',
                      style: GoogleFonts.robotoMono(
                        textStyle: TextStyle(
                          color: widget._textColor,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: widget.score.abs() >= 10 ? -1.25 : 0.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Animated overlay zones
          Column(
            children: [
              // Top half - increment zone
              Expanded(
                child: AnimatedBuilder(
                  animation: _topAnimation,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: _handleTopTap,
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: double.infinity,
                        color:
                            Color.fromRGBO(255, 255, 255, _topAnimation.value),
                      ),
                    );
                  },
                ),
              ),
              // Bottom half - decrement zone
              Expanded(
                child: AnimatedBuilder(
                  animation: _bottomAnimation,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: _handleBottomTap,
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: double.infinity,
                        color: Color.fromRGBO(
                            255, 255, 255, _bottomAnimation.value),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
