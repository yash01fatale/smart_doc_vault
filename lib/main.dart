import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/theme_controller.dart';
import 'core/utils/role_controller.dart';

import 'features/auth/screens/splash_screen.dart';

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
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(),
        ),
        ChangeNotifierProvider<RoleController>(
          create: (_) => RoleController(),
        ),
      ],
      child: Consumer2<ThemeController, RoleController>(
        builder: (context, themeController, roleController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smart Document Vault',

            // 🎨 THEMING
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,

            // 🧭 SINGLE ENTRY POINT
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
