import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/role_controller.dart';
import '../../../core/storage/local_storage.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _selectRole(
      BuildContext context,
      UserRole role) async {

    final roleController =
        Provider.of<RoleController>(
            context,
            listen: false);

    // Save role in provider
    await roleController.setRole(role);

    // Save role locally (optional but recommended)
    await LocalStorage.saveSelectedRole(
        role == UserRole.business
            ? "business"
            : "personal");

    // Navigate to Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [

                const SizedBox(height: 40),

                const Text(
                  "Choose Usage Type",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "How will you use Smart Document Vault?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

                _modernRoleCard(
                  icon: Icons.person_outline,
                  title: "Personal / Family",
                  subtitle:
                      "Store personal documents\nTrack expiry dates\nSecure family records",
                  onTap: () => _selectRole(
                      context, UserRole.personal),
                ),

                const SizedBox(height: 25),

                _modernRoleCard(
                  icon: Icons.business_outlined,
                  title: "Business User",
                  subtitle:
                      "Manage GST & licenses\nTrack compliance\nAvoid penalties",
                  onTap: () => _selectRole(
                      context, UserRole.business),
                ),

                const Spacer(),

                const Text(
                  "You can change this later in Settings",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _modernRoleCard({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4A00E0),
                    Color(0xFF8E2DE2),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
