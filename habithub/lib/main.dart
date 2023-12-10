import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habithub/firebase_options.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'Pages/LoginPage.dart';
import 'Data/habit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  Hive.registerAdapter(TimeOfDayAdapter()); // Register the TimeOfDayAdapter
  Hive.registerAdapter(HabitAdapter()); // Register the Hive adapter for Habit

  await Hive.openBox<Habit>('habits'); // Open a box for normal habits
  await Hive.openBox<Habit>('sharedHabits'); // Open a box for shared habits
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginPage(),
    );
  }
}
