import 'package:flutter/material.dart';

import 'CalendarPage.dart';
import 'MessagesPage.dart';
import 'ProfilePage.dart';
import 'SettingsPage.dart';
import 'SharedHabitsPage.dart';

class Habit {
  Habit({
    required this.name,
    required this.description,
    required this.time,
    required this.isShared,
    required this.friends,
    this.isChecked = false, // Add this line for checkbox state
  });

  final String name;
  final String description;
  final TimeOfDay time;
  final bool isShared;
  final List<String> friends;
  bool isChecked; // New property for checkbox state
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Define the habits list
  List<Habit> habits = [];

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
    switch (_selectedIndex) {
      case 0:
        return HomeWidget(habits: habits, onHabitClicked: _showHabitDetails);
      case 1:
        return SharedHabitsPage();
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
                    _addHabit(
                      habitNameController.text,
                      descriptionController.text,
                      selectedTime,
                      isShared,
                      friendsList,
                    );

                    Navigator.of(context).pop();
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
          decoration: InputDecoration(hintText: "Friends (comma-separated)"),
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
        if (friendsList.isNotEmpty) Text("Added Friends: ${friendsList.join(', ')}"),
      ],
    );
  }

  void _addHabit(
      String habitName,
      String description,
      TimeOfDay time,
      bool isShared,
      List<String> friends,
      ) {
    // Create a new habit with the provided details
    Habit newHabit = Habit(
      name: habitName,
      description: description,
      time: time,
      isShared: isShared,
      friends: friends,
    );

    // Add the new habit to your list of habits
    setState(() {
      habits.add(newHabit);
    });
  }

  void _showHabitDetails(Habit habit) {
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
          child: ListTile(
            title: Text(widget.habits[index].name),
            subtitle: Text(widget.habits[index].description),
            leading: Checkbox(
              value: widget.habits[index].isChecked,
              onChanged: (bool? value) {
                setState(() {
                  // Update the checked status of the habit
                  widget.habits[index].isChecked = value ?? false;
                });
              },
            ),
            onTap: () {
              widget.onHabitClicked(widget.habits[index]);
            },
          ),
        );
      },
    );
  }
}

