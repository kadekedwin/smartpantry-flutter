import 'package:flutter/material.dart';

class HeaderInventoryView extends StatelessWidget {
  // 1. Deklarasikan variabel (properti) untuk menampung teks dinamis
  final String title;
  final String subtitle;

  // 2. Masukkan variabel ke dalam constructor komponen
  const HeaderInventoryView({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF0F9F68),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        // Menghapus keyword 'const' di sini agar teks bisa dinamis
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, // 3. Ganti teks statis menjadi variabel 'title'
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle, // 4. Ganti teks statis menjadi variabel 'subtitle'
            style: const TextStyle(fontSize: 16, color: Color(0xFFE5E7EB)),
          ),
        ],
      ),
    );
  }
}
