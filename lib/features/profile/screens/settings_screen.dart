import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/role_controller.dart';
import '../../../shared/widgets/main_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _switchRole(
      BuildContext context,
      UserRole newRole) async {

    final roleController =
        Provider.of<RoleController>(
            context,
            listen: false);

    await roleController
        .setRole(newRole);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MainNavigation(
                userRole: newRole),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final roleController =
        Provider.of<RoleController>(
            context);

    final currentRole =
        roleController.role;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      /// 🌈 GRADIENT APPBAR
      appBar: AppBar(
        elevation: 0,
        flexibleSpace:
            Container(
          decoration:
              const BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                Color(
                    0xFF4A00E0),
                Color(
                    0xFF8E2DE2),
              ],
            ),
          ),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
              fontWeight:
                  FontWeight.bold),
        ),
      ),

      body: ListView(
        padding:
            const EdgeInsets.all(
                20),
        children: [

          /// =====================
          /// USAGE TYPE
          /// =====================
          _sectionTitle(
              "Usage Type"),

          _settingsCard(
            child: ListTile(
              leading: const Icon(
                Icons.swap_horiz,
                color:
                    Color(0xFF4A00E0),
              ),
              title: const Text(
                  "Switch Usage Type"),
              subtitle: Text(
                currentRole ==
                        UserRole.personal
                    ? "Currently: Personal / Family"
                    : "Currently: Business",
              ),
              trailing: const Icon(
                Icons
                    .arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                _showSwitchDialog(
                    context,
                    currentRole!);
              },
            ),
          ),

          const SizedBox(
              height: 30),

          /// =====================
          /// SECURITY
          /// =====================
          _sectionTitle("Security"),

          _settingsCard(
            child: Column(
              children: [

                SwitchListTile(
                  title: const Text(
                      "Two-Factor Authentication"),
                  subtitle:
                      const Text(
                          "Extra security during login"),
                  value: true,
                  activeColor:
                      const Color(
                          0xFF4A00E0),
                  onChanged:
                      (_) {},
                  secondary:
                      const Icon(
                    Icons
                        .verified_user_outlined,
                    color:
                        Color(
                            0xFF4A00E0),
                  ),
                ),

                const Divider(),

                SwitchListTile(
                  title:
                      const Text(
                          "App Lock"),
                  subtitle:
                      const Text(
                          "Require PIN or biometric"),
                  value: false,
                  activeColor:
                      const Color(
                          0xFF4A00E0),
                  onChanged:
                      (_) {},
                  secondary:
                      const Icon(
                    Icons
                        .lock_outline,
                    color:
                        Color(
                            0xFF4A00E0),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
              height: 30),

          /// =====================
          /// ABOUT
          /// =====================
          _sectionTitle("About"),

          _settingsCard(
            child: ListTile(
              leading: const Icon(
                Icons.info_outline,
                color:
                    Color(0xFF4A00E0),
              ),
              title: const Text(
                  "About Smart Document Vault"),
              subtitle:
                  const Text(
                      "Version 1.0.0"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName:
                      "Smart Document Vault",
                  applicationVersion:
                      "1.0.0",
                  applicationIcon:
                      const Icon(
                    Icons.folder_open,
                    color:
                        Color(
                            0xFF4A00E0),
                  ),
                  children: const [
                    Text(
                      "Smart Document Vault helps manage personal and business documents with smart expiry reminders.",
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  // 🔥 COMPONENTS
  // =============================

  Widget _settingsCard({
    required Widget child,
  }) {
    return Container(
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
                20),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(
      String title) {
    return Padding(
      padding:
          const EdgeInsets.only(
              bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  void _showSwitchDialog(
      BuildContext context,
      UserRole currentRole) {

    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  20),
        ),
        title: const Text(
            "Switch Usage Type"),
        content: const Text(
          "Your dashboard and document categories will change based on the selected usage type.",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(
                    context),
            child:
                const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton
                .styleFrom(
              backgroundColor:
                  const Color(
                      0xFF4A00E0),
            ),
            onPressed: () {
              Navigator.pop(
                  context);
              _switchRole(
                context,
                currentRole ==
                        UserRole
                            .personal
                    ? UserRole
                        .business
                    : UserRole
                        .personal,
              );
            },
            child:
                const Text(
              "Switch",
              style: TextStyle(
                  color:
                      Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
