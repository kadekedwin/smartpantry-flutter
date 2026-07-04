import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'services/token_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final token = await TokenStorage.read();
  runApp(SmartPantryApp(loggedIn: token != null && token.isNotEmpty));
}

class SmartPantryApp extends StatelessWidget {
  final bool loggedIn;
  const SmartPantryApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pantry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF059669)),
        useMaterial3: true,
      ),
      home: loggedIn ? const DashboardScreen() : const OnboardingScreen(),
    );
  }
}
