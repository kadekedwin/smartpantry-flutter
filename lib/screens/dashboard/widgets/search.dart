import 'package:flutter/material.dart';

class SearchBarView extends StatelessWidget {
  const SearchBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.0),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Cari bahan (misal: Daging)',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF9CA3AF),
                  size: 24,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.filter_list_rounded, // Ikon corong filter yang lebih presisi
            color: Color(0xFF1F2937),
            size: 28,
          ),
        ),
      ],
    );
  }
}
