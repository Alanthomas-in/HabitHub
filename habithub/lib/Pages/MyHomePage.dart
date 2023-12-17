import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Data/habit.dart';
import 'CalendarPage.dart';
import 'MessagesPage.dart';
import 'ProfilePage.dart';
import 'SettingsPage.dart';
import 'SharedHabitsPage.dart';

List<Habit> sharedHabits = [];

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Define the habits list
  List<Habit> habits = [];

  late Box<Habit> habitsBox;
  late Box<Habit> sharedHabitsBox;

  void initState() {
    super.initState();
    // habitsBox = Hive.box<Habit>('habits');
    // sharedHabitsBox = Hive.box<Habit>('sharedHabits');
    habits = Hive.box<Habit>('habits').values.toList();
    sharedHabits = Hive.box<Habit>('sharedHabits').values.toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDrawerItemClicked(int index) {
    switch (index) {
      case 0:
      // Home (do nothing)
        break;
      case 1:
      // Messages
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagesPage()));
        break;
      case 2:
      // Profile
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
      case 3:
      // Settings
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitHub'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ));
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "U",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
              onTap: () {
                _onDrawerItemClicked(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                _onDrawerItemClicked(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                _onDrawerItemClicked(3);
              },
            ),
          ],
        ),
      ),
      body: _getSelectedWidget(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          _showAddHabitDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Shared',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event), // Changed to Event icon
            label: 'Calendar', // Changed label to Calendar
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getSelectedWidget() {
    habits = Hive.box<Habit>('habits').values.toList();
    sharedHabits = Hive.box<Habit>('sharedHabits').values.toList();
    switch (_selectedIndex) {
      case 0:
        return HomeWidget(habits: habits, onHabitClicked: _showHabitDetails);
      case 1:
        return SharedHabitsPage(sharedHabits: sharedHabits); // Pass sharedHabits to the SharedHabitsPage
      case 2:
        return CalendarPage(); // Change to your Calendar page widget
      default:
        return Container(); // Handle the case where an invalid index is provided
    }
  }

  void _showAddHabitDialog(BuildContext context) {
    TextEditingController habitNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    TextEditingController friendsController = TextEditingController();
    bool isShared = false;
    List<String> friendsList = [];
    int totalDays = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add a new habit'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: habitNameController,
                      decoration: InputDecoration(hintText: "Habit name"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: "Description"),
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectTime(context, selectedTime, (time) {
                          setState(() {
                            selectedTime = time;
                          });
                        });
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: selectedTime.format(context),
                          ),
                          decoration: InputDecoration(hintText: "Time for notification"),
                        ),
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(
                        text: totalDays.toString(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          totalDays = int.parse(value);
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Total Days"),
                    ),
                    if (totalDays == 0)
                      Text(
                        'Total days cannot be 0.',
                        style: TextStyle(color: Colors.red),
                      ),
                    CheckboxListTile(
                      title: Text("Shared"),
                      value: isShared,
                      onChanged: (newValue) {
                        setState(() {
                          isShared = newValue ?? false;
                          if (!isShared) {
                            friendsList.clear();
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (isShared)
                      _buildFriendsInput(context, friendsController, friendsList, setState),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    if (totalDays == 0) {
                      _showToast(context, 'Total days cannot be 0.');
                    } else {
                      _addHabit(
                        habitNameController.text,
                        descriptionController.text,
                        selectedTime,
                        isShared,
                        friendsList,
                        totalDays,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildFriendsInput(
      BuildContext context,
      TextEditingController friendsController,
      List<String> friendsList,
      StateSetter setState,
      ) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (value) {
            setState(() {
              friendsList.clear();
              friendsList.addAll(value.split(',').map((e) => e.trim()));
            });
          },
          controller: friendsController,
          decoration: InputDecoration(labelText: "Friends (comma-separated)"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              friendsList.add(friendsController.text);
              friendsController.clear();
            });
          },
          child: Text("Add More"),
        ),
        if (friendsList.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Added Friends:"),
              for (String friend in friendsList)
                Row(
                  children: [
                    Text(friend),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          friendsList.remove(friend);
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }


  void _addHabit(
      String habitName,
      String description,
      TimeOfDay time,
      bool isShared,
      List<String> friends,
      int totalDays,
      ) async {
    final habitBox = Hive.box<Habit>(isShared ? 'sharedHabits' : 'habits');

    Habit newHabit = Habit(
      name: habitName,
      description: description,
      time: time,
      isShared: isShared,
      friends: friends,
      totalDays: totalDays,
    );

    await habitBox.add(newHabit);

    setState(() {
      habits.add(newHabit);
      if (isShared) {
        sharedHabits.add(newHabit);
      }
    });
    print(habitsBox.values); // Print habits data
    print(sharedHabitsBox.values); // Print sharedHabits data
  }

  void _showHabitDetails(Habit habit) {
    TextEditingController habitNameController = TextEditingController(text: habit.name);
    TextEditingController descriptionController = TextEditingController(text: habit.description);
    TimeOfDay selectedTime = habit.time;
    TextEditingController friendsController = TextEditingController(text: habit.friends.join(', '));
    bool isShared = habit.isShared;
    List<String> friendsList = List.from(habit.friends);
    int totalDays = habit.totalDays;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Habit Details'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: habitNameController,
                      decoration: InputDecoration(labelText: 'Habit name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectTime(context, selectedTime, (time) {
                          setState(() {
                            selectedTime = time;
                          });
                        });
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: selectedTime.format(context),
                          ),
                          decoration: InputDecoration(labelText: 'Time for notification'),
                        ),
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(
                        text: totalDays.toString(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          totalDays = int.parse(value);
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Total Days'),
                    ),
                    if (totalDays == 0)
                      Text(
                        'Total days cannot be 0.',
                        style: TextStyle(color: Colors.red),
                      ),
                    CheckboxListTile(
                      title: Text('Shared'),
                      value: isShared,
                      onChanged: (newValue) {
                        setState(() {
                          isShared = newValue ?? false;
                          if (!isShared) {
                            friendsList.clear();
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (isShared)
                      _buildFriendsInput(context, friendsController, friendsList, setState),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (totalDays == 0) {
                      _showToast(context, 'Total days cannot be 0.');
                    } else {
                      _updateHabit(
                        habit,
                        habitNameController.text,
                        descriptionController.text,
                        selectedTime,
                        isShared,
                        friendsList,
                        totalDays,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteHabit(habit);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateHabit(
      Habit habit,
      String habitName,
      String description,
      TimeOfDay time,
      bool isShared,
      List<String> friends,
      int totalDays,
      ) async {
    final habitBox = Hive.box<Habit>(isShared ? 'sharedHabits' : 'habits');

    habit.name = habitName;
    habit.description = description;
    habit.time = time;
    habit.isShared = isShared;
    habit.friends = friends;
    habit.totalDays = totalDays;

    await habitBox.put(habit.key, habit);
  }

  void _deleteHabit(Habit habit) async {
    setState(() {
      habits.remove(habit);
      if (habit.isShared) {
        sharedHabits.remove(habit);
      }
    });

    final habitBox = Hive.box<Habit>(habit.isShared ? 'sharedHabits' : 'habits');
    await habitBox.delete(habit.key);
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }


  Future<void> _selectTime(
      BuildContext context,
      TimeOfDay initialTime,
      Function(TimeOfDay) onTimeSelected,
      ) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null && selectedTime != initialTime) {
      onTimeSelected(selectedTime);
    }
  }
}

class HomeWidget extends StatefulWidget {
  final List<Habit> habits;
  final Function(Habit) onHabitClicked;

  HomeWidget({required this.habits, required this.onHabitClicked});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.habits.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            tileColor: widget.habits[index].isChecked ? Colors.green[100] : null,
            title: Text(
              widget.habits[index].name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.habits[index].isChecked ? Colors.green[800] : null,
              ),
            ),
            subtitle: Text(
              widget.habits[index].description,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            leading: Checkbox(
              value: widget.habits[index].isChecked,
              onChanged: (bool? value) {
                _handleCheckboxChange(widget.habits[index]);
              },
              activeColor: Colors.deepPurple,
            ),
            trailing: widget.habits[index].isChecked
                ? CircularProgressIndicator(
              value: widget.habits[index].progress / widget.habits[index].totalDays,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            )
                : null,
            onTap: () {
              widget.onHabitClicked(widget.habits[index]);
            },
          ),
        );
      },
    );
  }

  void _handleCheckboxChange(Habit habit) {
    if (habit.isChecked) {
      _uncheckHabit(habit);
    } else {
      _checkHabit(habit);
    }
  }

  void _checkHabit(Habit habit) {
    setState(() {
      habit.isChecked = true;
      DateTime now = DateTime.now();
      DateTime habitTime = DateTime(
        now.year,
        now.month,
        now.day,
        habit.time.hour,
        habit.time.minute,
      );

      if (now.isBefore(habitTime.add(Duration(hours: 23)))) {
        habit.progress += 1;
        Hive.box<Habit>('habits').put(habit.key, habit);
      }
    });
  }

  void _uncheckHabit(Habit habit) {
    setState(() {
      habit.isChecked = false;
      DateTime now = DateTime.now();
      DateTime habitTime = DateTime(
        now.year,
        now.month,
        now.day,
        habit.time.hour,
        habit.time.minute,
      );

      // Check if it's after midnight
      if (now.isAfter(habitTime.add(Duration(hours: 23)))) {
        // If it's after midnight, update the progress for the new day
        habit.progress = 0;
      } else {
        // If it's still the same day, decrement the progress
        habit.progress -= 1;
        if (habit.progress < 0) {
          habit.progress = 0;
        }
      }

      Hive.box<Habit>('habits').put(habit.key, habit);
    });
  }

}
