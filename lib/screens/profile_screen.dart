import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('User Profile', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            const Text('Name: John Doe'),
            const Text('Email: john.doe@example.com'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logout functionality
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
