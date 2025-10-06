import 'package:flutter/material.dart';

class ScorePanel extends StatefulWidget {
  final Color _panelColor;
  final Color _textColor;

  const ScorePanel(
      {Key? key, required Color panelColor, required Color textColor})
      : _panelColor = panelColor,
        _textColor = textColor,
        super(key: key);

  @override
  State<ScorePanel> createState() => _ScorePanelState();
}

class _ScorePanelState extends State<ScorePanel> {
  int _score = 0;

  void _incrementScore() {
    setState(() {
      _score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _incrementScore,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: widget._panelColor,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Center(
            child: Text(
              '$_score',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: widget._textColor, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}
