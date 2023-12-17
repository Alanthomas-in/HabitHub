import 'package:flutter/material.dart';
import '../Data/habit.dart';

class SharedHabitsPage extends StatefulWidget {
  final List<Habit> sharedHabits;

  SharedHabitsPage({required this.sharedHabits});

  @override
  _SharedHabitsPageState createState() => _SharedHabitsPageState();
}

class _SharedHabitsPageState extends State<SharedHabitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.sharedHabits.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                widget.sharedHabits[index].name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.sharedHabits[index].description),
              onTap: () {
                _showHabitDetails(context, widget.sharedHabits[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _showHabitDetails(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Habit Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                _buildDetailRow('Name', habit.name),
                _buildDetailRow('Description', habit.description),
                _buildDetailRow('Time', habit.time.format(context)),
                _buildDetailRow('Shared', habit.isShared ? 'Yes' : 'No'),
                if (habit.isShared) _buildDetailRow('Friends', habit.friends.join(', ')),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
