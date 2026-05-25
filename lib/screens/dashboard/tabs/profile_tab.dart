import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  static const _primary = Color(0xFF059669);
  static const _foreground = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildTitle(),
            const SizedBox(height: 32),
            _buildAvatar(),
            const SizedBox(height: 12),
            _buildUserInfo(),
            const SizedBox(height: 16),
            _buildEditButton(),
            const SizedBox(height: 32),
            _buildMenuItems(),
            const SizedBox(height: 24),
            _buildLogOutButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'My Profile',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: _foreground,
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _primary.withAlpha(60), width: 2),
        image: const DecorationImage(
          image: AssetImage('assets/images/profile.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return const Column(
      children: [
        Text(
          'John',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _foreground,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'anonymous@gmail.com',
          style: TextStyle(fontSize: 14, color: _muted),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: _primary,
            side: const BorderSide(color: _primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    final items = [
      (Icons.receipt_long_outlined, 'Shopping History'),
      (Icons.favorite_border, 'Favorite'),
      (Icons.info_outline, 'Information'),
      (Icons.settings_outlined, 'Settings'),
    ];

    return Column(
      children: items
          .map((item) => _MenuItem(icon: item.$1, label: item.$2))
          .toList(),
    );
  }

  Widget _buildLogOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Log Out',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF374151)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
