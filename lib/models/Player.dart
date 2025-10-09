import 'package:flutter/material.dart';

class Player {
  String? dbId;
  String name;
  Color bgColor;
  Color textColor;
  int score;

  Player({
    this.dbId,
    required this.name,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
    this.score = 0,
  });
}
