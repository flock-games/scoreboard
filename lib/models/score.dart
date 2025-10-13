import 'package:flutter/material.dart';

class Score {
  String? dbId;
  String name;
  Color bgColor;
  Color textColor;
  int points;

  Score({
    this.dbId,
    required this.name,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
    this.points = 0,
  });
}
