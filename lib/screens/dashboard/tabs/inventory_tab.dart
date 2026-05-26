import 'package:flutter/material.dart';

class InventoryTab extends StatelessWidget {
  const InventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        // Menggunakan Column agar bisa memasukkan banyak widget (children) secara vertikal
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            // Expanded + Center akan membuat konten ikon berada tepat di tengah sisa layar
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 100,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your inventory will appear here.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
