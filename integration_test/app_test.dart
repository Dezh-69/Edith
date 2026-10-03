import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:edith/screens/home_screen.dart';
import 'package:edith/services/local_storage_service.dart';
import 'package:edith/services/auto_save_service.dart';
import 'package:edith/theme/app_theme.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E UI Tests', () {
    testWidgets('e2e_app_launch_showsHomeScreen', (WidgetTester tester) async {
      // Initialize services the same way main() does,
      // but without calling WidgetsFlutterBinding.ensureInitialized() again
      // (IntegrationTestWidgetsFlutterBinding already covers it).
      await LocalStorageService().init();
      AutoSaveService().start();

      await tester.pumpWidget(
        MaterialApp(
          title: 'Edith',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      );

      // Allow async frame settling (loading data, building widgets)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // The AppBar title contains the text 'Edith' (home_screen.dart line 184)
      expect(find.text('Edith'), findsOneWidget);

      // The AppBar subtitle shows 'Library' (home_screen.dart line 194)
      expect(find.text('Library'), findsAtLeastNWidgets(1));
    });
  });
}
