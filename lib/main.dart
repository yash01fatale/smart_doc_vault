import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/theme_controller.dart';
import 'core/utils/role_controller.dart';

import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/role_selection_screen.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartDocVaultApp());
}

class SmartDocVaultApp extends StatelessWidget {
  const SmartDocVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => RoleController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Document Vault',

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,

            // 🔥 IMPORTANT FOR WEB REFRESH
            initialRoute: '/',

            routes: {
              '/': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/role': (context) => const RoleSelectionScreen(),
              '/login': (context) => const LoginScreen(),

            },
            // 🔥 This makes web refresh work properly
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (_) => const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
