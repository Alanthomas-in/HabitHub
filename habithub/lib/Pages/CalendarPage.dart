import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Data/CompletedHabits.dart';
import '../Data/habit.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<Habit> completedHabits = [];

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _updateCompletedHabitsList(); // Add this line to update the list initially
  }

  CompletedHabits? _getCompletedHabits(DateTime date) {
    final completedHabitsBox = Hive.box<CompletedHabits>('completedHabits');
    try {
      return completedHabitsBox.values.firstWhere(
            (completedHabit) => isSameDay(completedHabit.date, date),
        orElse: () => throw StateError('Not found'),
      );
    } catch (e) {
      return null;
    }
  }

  void _updateCompletedHabitsList() {
    setState(() {
      completedHabits = _getCompletedHabitsList(_selectedDay);
      // print("Completed Habits List:");
      // for (Habit habit in completedHabits) {
      //   print(habit.name);
      // }
    });
  }

  List<Habit> _getCompletedHabitsList(DateTime date) {
    CompletedHabits? completedHabitsData = _getCompletedHabits(date);
    return completedHabitsData?.completedHabits.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TableCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2023, 12, 31),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _updateCompletedHabitsList();
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
        ),
      ),
      bottomSheet: completedHabits.isNotEmpty
          ? Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Habits',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            for (Habit habit in completedHabits)
              Text(
                habit.name,
                style: TextStyle(fontSize: 14),
              ),
          ],
        ),
      )
          : null,
    );
  }
}
