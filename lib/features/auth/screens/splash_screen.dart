import 'package:flutter/material.dart';
import '../../../core/storage/local_storage.dart';
import '../../documents/screens/dashboard_screen.dart';
import '../../auth/screens/login_screen.dart';
import 'role_selection_screen.dart';
import 'onboarding_screen.dart';
import '../../../core/utils/role_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    _checkFlow();
  }

  Future<void> _checkFlow() async {

    await Future.delayed(const Duration(seconds: 3));

    bool isFirstTime = await LocalStorage.isFirstTime();
    final token = await LocalStorage.getToken();
    final role = await LocalStorage.getRole();

    if (!mounted) return;

    // 🟢 FIRST TIME → ONBOARDING
    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }

    // 🟡 NOT LOGGED IN → ROLE SELECTION
    if (token == null || role == null) {
      Navigator.pushReplacementNamed(context, '/role');

      return;
    }

    // 🔵 LOGGED IN → DASHBOARD
    Navigator.pushReplacementNamed(context, '/dashboard');

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔥 APP ICON
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.folder_open,
                  size: 50,
                  color: Color(0xFF4A00E0),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Smart Document Vault",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Manage. Protect. Stay Ahead.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
