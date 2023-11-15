import 'package:flutter/material.dart';

import 'AccountPage.dart';
import 'SharedHabitsPage.dart';

class Habit {
  Habit({
    required this.name,
    required this.description,
    required this.time,
    required this.isShared,
    required this.friends,
  });

  final String name;
  final String description;
  final String time;
  final bool isShared;
  final List<String> friends;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitHub'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("User Name"),
              accountEmail: Text("user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "U",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
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
            icon: Icon(Icons.account_circle),
            label: 'Account',
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
        return HomeWidget(habits: habits);
      case 1:
        return SharedHabitsPage();
      case 2:
        return AccountPage();
      default:
        return Container(); // Handle the case where an invalid index is provided
    }
  }

  void _showAddHabitDialog(BuildContext context) {
    TextEditingController habitNameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController timeController = TextEditingController();
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
              content: Column(
                children: <Widget>[
                  TextField(
                    controller: habitNameController,
                    decoration: InputDecoration(hintText: "Habit name"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                  TextField(
                    controller: timeController,
                    decoration: InputDecoration(hintText: "Time for notification"),
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
                    _buildFriendsInput(context, friendsController, friendsList),
                ],
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
                      timeController.text,
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
        if (friendsList.isNotEmpty)
          Text("Added Friends: ${friendsList.join(', ')}"),
      ],
    );
  }

  void _addHabit(
      String habitName,
      String description,
      String time,
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
}

class HomeWidget extends StatelessWidget {
  final List<Habit> habits;

  HomeWidget({required this.habits});

  @override
  Widget build(BuildContext context) {
    // Display the list of habits here
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(habits[index].name),
            subtitle: Text(habits[index].description),
          ),
        );
      },
    );
  }
}
