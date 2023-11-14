import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New User'),
      ),
      body: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter your username'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Enter your password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Add your logic here to create a new user
              },
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}