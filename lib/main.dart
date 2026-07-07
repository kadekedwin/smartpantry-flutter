import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/dashboard/tabs/home_tab.dart';
import 'screens/dashboard/tabs/inventory_tab.dart';
import 'screens/dashboard/tabs/add_tab.dart';
import 'screens/dashboard/tabs/notification_tab.dart';
import 'screens/dashboard/tabs/profile_tab.dart';
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
      initialRoute: loggedIn ? '/' : '/onboarding',
      routes: {
        '/': (context) => const MainNavigationScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeTab(),
        '/inventory': (context) => const InventoryTab(),
        '/add': (context) => const AddTab(),
        '/notification': (context) => const NotificationTab(),
        '/profile': (context) => const ProfileTab(),
      },
    );
  }
}
