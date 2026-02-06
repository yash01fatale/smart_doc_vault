import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

enum SignupRole { personal, business }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  final businessNameController = TextEditingController();
  final businessTypeController = TextEditingController();
  final gstController = TextEditingController();

  SignupRole role = SignupRole.personal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: mobileController,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 20),

            // ROLE SELECTION
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Personal"),
                    value: SignupRole.personal,
                    groupValue: role,
                    onChanged: (value) {
                      setState(() => role = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Business"),
                    value: SignupRole.business,
                    groupValue: role,
                    onChanged: (value) {
                      setState(() => role = value!);
                    },
                  ),
                ),
              ],
            ),

            if (role == SignupRole.business) ...[
              const SizedBox(height: 16),
              TextField(
                controller: businessNameController,
                decoration:
                    const InputDecoration(labelText: "Business Name"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: businessTypeController,
                decoration:
                    const InputDecoration(labelText: "Business Type"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: gstController,
                decoration: const InputDecoration(
                    labelText: "GST Number (optional)"),
              ),
            ],

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: API signup + save to DB
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(),
                    ),
                  );
                },
                child: const Text("Create Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
