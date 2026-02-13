import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:smart_doc_vault/main.dart';
import 'package:smart_doc_vault/core/utils/theme_controller.dart';
import 'package:smart_doc_vault/core/utils/role_controller.dart';
import 'package:smart_doc_vault/features/auth/screens/splash_screen.dart';

void main() {

  testWidgets('App loads and shows SplashScreen',
      (WidgetTester tester) async {

    // Build app with required providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeController()),
          ChangeNotifierProvider(create: (_) => RoleController()),
        ],
        child: const SmartDocVaultApp(),
      ),
    );

    // Wait for initial frame
    await tester.pump();

    // Verify SplashScreen exists
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
