import 'package:flutter/material.dart';
import '../../core/utils/role_controller.dart';
import '../../features/documents/screens/dashboard_screen.dart';
import '../../features/documents/screens/ai_assistant_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final UserRole userRole;

  const MainNavigation({super.key, required this.userRole});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        DashboardScreen(userRole: widget.userRole),
        const AIAssistantScreen(),
        const NotificationsScreen(),
        const ProfileScreen(),
      ][_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // IMPORTANT
        selectedItemColor: Colors.indigo,
        unselectedItemColor:
            Colors.grey.shade600, // visible always
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: "AI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: "Alerts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
