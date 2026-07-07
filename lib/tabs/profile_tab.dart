import 'package:flutter/material.dart';
import 'package:smartpantry/screens/components/tab_header.dart';
import '../../../data/models/user.dart';
import '../../../services/profile_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_client.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  static const _green = Color(0xFF0F9F68);
  static const _foreground = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _bg = Color(0xFFF9FAFB);

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
      backgroundColor: _bg,
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
                      _buildProfileInfo(snapshot),
                      const SizedBox(height: 32),
                      _buildLogoutButton(),
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

  Widget _buildProfileInfo(AsyncSnapshot<User> snapshot) {
    String name = '...';
    String email = '...';
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        final err = snapshot.error;
        name = 'Gagal memuat';
        email = err is ApiException ? err.message : 'Tidak terhubung';
      } else if (snapshot.hasData) {
        name = snapshot.data!.name;
        email = snapshot.data!.email;
      }
    }
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _green, width: 3),
            image: const DecorationImage(
              image: AssetImage('assets/images/profile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _foreground,
          ),
        ),
        const SizedBox(height: 4),
        Text(email, style: const TextStyle(fontSize: 13, color: _muted)),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _loggingOut ? null : _logout,
        icon: _loggingOut
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.logout_rounded, size: 18),
        label: const Text(
          'Log Out',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
