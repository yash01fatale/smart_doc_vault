import 'package:flutter/material.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.person,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 12),
            const Text(
              "User Name",
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text("user@email.com"),
            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              trailing:
                  const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
