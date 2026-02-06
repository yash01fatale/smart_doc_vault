import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/role_controller.dart';
import '../../../shared/widgets/main_navigation.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _selectRole(BuildContext context, UserRole role) async {
    final roleController =
        Provider.of<RoleController>(context, listen: false);

    await roleController.setRole(role);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(userRole: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Usage Type")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "How will you use Smart Document Vault?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            _roleCard(
              context,
              icon: Icons.person_outline,
              title: "Personal / Family",
              subtitle:
                  "Store personal and family documents and track expiry dates.",
              onTap: () =>
                  _selectRole(context, UserRole.personal),
            ),

            const SizedBox(height: 20),

            _roleCard(
              context,
              icon: Icons.business_outlined,
              title: "Business User",
              subtitle:
                  "Manage business licenses, GST, compliance documents.",
              onTap: () =>
                  _selectRole(context, UserRole.business),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(icon,
                  color: Theme.of(context).primaryColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle,
                      style:
                          TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
