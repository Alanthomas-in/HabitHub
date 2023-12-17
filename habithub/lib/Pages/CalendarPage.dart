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

  List<CompletedHabits> _getCompletedHabits(DateTime date) {
    final completedHabitsBox = Hive.box<CompletedHabits>('completedHabits');
    return completedHabitsBox.values.where((element) => isSameDay(element.date, date)).toList();
  }

  void _updateCompletedHabitsList() {
    setState(() {
      completedHabits = _getCompletedHabitsList(_selectedDay);
    });
  }

  List<Habit> _getCompletedHabitsList(DateTime date) {
    List<CompletedHabits> completedHabitsData = _getCompletedHabits(date);
    List<Habit> completedHabitsList = [];

    for (int i = 0; i < completedHabitsData.length; i++) {
      completedHabitsList = completedHabitsList + completedHabitsData[i].completedHabits.toList();
    }

    return completedHabitsList;
  }

  void _showCompletedHabitsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Completed Habits',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 12),
                  Divider(
                    color: Colors.blue,
                  ),
                  SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: completedHabits.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          completedHabits[index].name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TableCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCompletedHabitsDialog();
        },
        child: Icon(Icons.list),
      ),
    );
  }
}
