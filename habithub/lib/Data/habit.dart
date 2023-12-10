import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late TimeOfDay time;

  @HiveField(3)
  late bool isShared;

  @HiveField(4)
  late List<String> friends;

  @HiveField(5)
  bool isChecked;

  @HiveField(6)
  late int totalDays;

  @HiveField(7)
  int progress;

  Habit({
    required this.name,
    required this.description,
    required this.time,
    required this.isShared,
    required this.friends,
    this.isChecked = false,
    required this.totalDays,
    this.progress = 0,
  });
}
