import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Auth.dart';

import 'CreateUserPage.dart';
import 'MyHomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? errorMessage = '';
  late bool _isLoggedIn = false; // Declare _isLoggedIn as late
  bool _loading = false; // Add a variable to track loading state

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLoginStatus(); // Load login status on initialization
  }

  Future<void> _loadLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      setState(() {
        _loading = true; // Show loading animation
      });

      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      _saveLoginStatus(true); // Save login status on successful login
      setState(() {
        _isLoggedIn = true;
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Failed to sign in: ';

      if (e.code == 'user-not-found') {
        errorMessage += 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage += 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage += 'The email address is not valid.';
      }

      // Display the error message in a pop-up dialog
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: errorMessage,
      );

      print(errorMessage);
    } finally {
      setState(() {
        _loading = false; // Hide loading animation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isLoggedIn ? MyHomePage() : Scaffold(
          appBar: AppBar(
            title: Text('Habit Hub'),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        labelText: 'Enter your Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _controllerPassword,
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          signInWithEmailAndPassword();
                        }
                      },
                      child: Text('Login'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.deepPurple,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateUserPage(context)),
                        );
                      },
                      child: Text('Create New User'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Loading animation overlay
        if (_loading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color(0xFF0000FF),
                rightDotColor: const Color(0xFFFFFFFF),
                size: 50,
              ),
            ),
          ),
      ],
    );
  }
}
