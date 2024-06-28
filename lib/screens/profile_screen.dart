import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Profile', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Name: John Doe'),
            Text('Email: john.doe@example.com'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logout functionality
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}