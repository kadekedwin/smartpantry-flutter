import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/profile_service.dart';
import '../components/tabs/home_header.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final Future<User> _userFuture = ProfileService.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [HomeHeader(userFuture: _userFuture)],
      ),
    );
  }
}
