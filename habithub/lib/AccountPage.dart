// New Page for Account page
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to your Account Page!',
              style: TextStyle(fontSize: 20),
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}
