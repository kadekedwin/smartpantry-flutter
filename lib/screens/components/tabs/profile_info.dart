import 'package:flutter/material.dart';
import '../../../data/models/user.dart';
import '../../../services/api_client.dart';

class ProfileInfo extends StatelessWidget {
  final AsyncSnapshot<User> snapshot;

  const ProfileInfo({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
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
            border: Border.all(color: const Color(0xFF0F9F68), width: 3),
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
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
