import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../components/tab_header.dart';
import '../components/tabs/profile_info.dart';
import '../components/tabs/profile_logout_button.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late Future<User> _future;
  bool _loggingOut = false;

  @override
  void initState() {
    super.initState();
    _future = ProfileService.get();
  }

  Future<void> _logout() async {
    if (_loggingOut) return;
    setState(() => _loggingOut = true);
    try {
      await AuthService.logout();
    } catch (_) {
      // ignore, we clear token regardless
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: FutureBuilder<User>(
        future: _future,
        builder: (context, snapshot) {
          return Column(
            children: [
              const TabHeader(
                title: 'My Profile',
                subtitle: 'Kelola akun Anda',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                  child: Column(
                    children: [
                      ProfileInfo(snapshot: snapshot),
                      const SizedBox(height: 32),
                      ProfileLogoutButton(
                        loading: _loggingOut,
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
