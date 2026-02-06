import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/role_controller.dart';
import '../../../shared/widgets/main_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _switchRole(BuildContext context, UserRole newRole) async {
    final roleController =
        Provider.of<RoleController>(context, listen: false);

    await roleController.setRole(newRole);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(userRole: newRole),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleController = Provider.of<RoleController>(context);
    final currentRole = roleController.role;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle("Usage Type"),

          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text("Switch Usage Type"),
            subtitle: Text(
              currentRole == UserRole.personal
                  ? "Currently: Personal / Family"
                  : "Currently: Business",
            ),
            trailing:
                const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Switch Usage Type"),
                  content: const Text(
                    "Are you sure you want to switch usage type? "
                    "Your dashboard and document categories will change.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _switchRole(
                          context,
                          currentRole == UserRole.personal
                              ? UserRole.business
                              : UserRole.personal,
                        );
                      },
                      child: const Text("Switch"),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 40),

          _sectionTitle("Security"),

          SwitchListTile(
            title: const Text("Two-Factor Authentication"),
            subtitle:
                const Text("Extra security during login"),
            value: true,
            onChanged: (_) {},
            secondary:
                const Icon(Icons.verified_user_outlined),
          ),

          SwitchListTile(
            title: const Text("App Lock"),
            subtitle:
                const Text("Require PIN or biometric"),
            value: false,
            onChanged: (_) {},
            secondary: const Icon(Icons.lock_outline),
          ),

          const Divider(height: 40),

          _sectionTitle("About"),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Smart Document Vault"),
            subtitle: const Text("Version 1.0.0"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Smart Document Vault",
                applicationVersion: "1.0.0",
                applicationIcon:
                    const Icon(Icons.folder_open),
                children: const [
                  Text(
                    "Smart Document Vault helps manage personal and business documents with smart expiry reminders.",
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
