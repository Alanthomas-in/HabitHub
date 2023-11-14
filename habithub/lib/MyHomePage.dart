import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
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
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Shared Habits'),
    Text('Account'),
  ];

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
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
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
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(habits[index].name),
              subtitle: Text(habits[index].description),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController habitNameController = TextEditingController();
          TextEditingController descriptionController = TextEditingController();
          TextEditingController timeController = TextEditingController();
          TextEditingController friendsController = TextEditingController();
          bool isShared = false;

          showDialog(
            context: context,
            builder: (BuildContext context) {
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
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                    TextField(
                      controller: friendsController,
                      decoration: InputDecoration(hintText: "Friends"),
                    ),
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
                      // Add your habit addition code here
                      String habitName = habitNameController.text;
                      String description = descriptionController.text;
                      String time = timeController.text;
                      List<String> friends = friendsController.text.split(',');

                      // Create a new habit with the provided details
                      Habit newHabit = Habit(
                        name: habitName,
                        description: description,
                        time: time,
                        isShared: isShared,
                        friends: friends,
                      );

                      // Add the new habit to your list of habits
                      habits.add(newHabit);

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),


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
}