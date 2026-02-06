import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 15),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 15),

            TextField(
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                // backend later
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
