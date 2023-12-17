import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'habit.dart';

part 'CompletedHabits.g.dart';

@HiveType(typeId: 1)
class CompletedHabits extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late List<Habit> completedHabits;

  CompletedHabits({
    required this.date,
    required this.completedHabits,
  });
}
