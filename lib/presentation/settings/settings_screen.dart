import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guru_ai/api_service/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          // ListTile(
          //   title: const Text('Theme'),
          //   subtitle: const Text('Change app theme'),
          //   onTap: () {
          //     // Navigate to theme settings
          //   },
          // ),
          // ListTile(
          //   title: const Text('Notifications'),
          //   subtitle: const Text('Manage notification preferences'),
          //   onTap: () {
          //     // Navigate to notification settings
          //   },
          // ),
          // ListTile(
          //   title: const Text('Privacy'),
          //   subtitle: const Text('Adjust privacy settings'),
          //   onTap: () {
          //     // Navigate to privacy settings
          //   },
          // ),
          // ListTile(
          //   title: const Text('About'),
          //   subtitle: const Text('Learn more about the app'),
          //   onTap: () {
          //     // Navigate to about page
          //   },
          // ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(ApiEndPoint.auth);
            },
          ),
        ],
      ),
    );
  }
}
