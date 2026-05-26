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
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Cari bahan (misal: Daging)',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Color(0xFF9CA3AF),
                  size: 22,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF0F9F68),
              size: 22,
            ),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
