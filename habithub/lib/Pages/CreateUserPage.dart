import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New User'),
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
                  decoration: InputDecoration(
                    labelText: 'Enter your username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0), // Add space between the fields
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16.0), // Add space between the fields
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple, // background color
                    onPrimary: Colors.white, // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    // Add your logic here to create a new user
                    // After creating the user, navigate back to the login page
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Create User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
