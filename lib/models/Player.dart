import 'package:flutter/material.dart';

class Player {
  String name;
  Color bgColor;
  Color textColor;
  int score;

  Player({
    required this.name,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
    this.score = 0,
  });
}
