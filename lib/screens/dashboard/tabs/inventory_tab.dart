import 'package:flutter/material.dart';
import '../widgets/search.dart';
import '../widgets/header.dart';
import '../../../datas/inventory_data.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  String activeCategory = 'kulkas';

  Color _getExpiryColor(String info) {
    if (info.contains('Hari')) {
      final days = int.tryParse(info.split(' ')[0]) ?? 999;
      if (days <= 2) return const Color(0xFFEF4444);
      if (days <= 5) return const Color(0xFFF59E0B);
    }
    return const Color(0xFF0F9F68);
  }

  int _countByCategory(String category) =>
      dummyInventoryData.where((e) => e.category == category).length;

  @override
  Widget build(BuildContext context) {
    final filteredData = dummyInventoryData
        .where((item) => item.category == activeCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          HeaderInventoryView(
            title: 'Inventory',
            subtitle: 'Stok saya',
            onAddPressed: () {},
            stats: [
              HeaderStat(
                label: 'Kulkas',
                value: '${_countByCategory('kulkas')}',
              ),
              HeaderStat(
                label: 'Freezer',
                value: '${_countByCategory('freezer')}',
              ),
              HeaderStat(
                label: 'Rak Dapur',
                value: '${_countByCategory('rak_dapur')}',
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: SearchBarView(),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                _buildPillTab(
                  icon: Icons.kitchen_rounded,
                  label: 'Kulkas',
                  categoryKey: 'kulkas',
                ),
                const SizedBox(width: 8),
                _buildPillTab(
                  icon: Icons.ac_unit_rounded,
                  label: 'Freezer',
                  categoryKey: 'freezer',
                ),
                const SizedBox(width: 8),
                _buildPillTab(
                  icon: Icons.layers_rounded,
                  label: 'Rak Dapur',
                  categoryKey: 'rak_dapur',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: filteredData.isEmpty
                ? const Center(
                    child: Text('Tidak ada barang di kategori ini'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      final expiryColor = _getExpiryColor(item.expiredInfo);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    item.icon,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Stok: ${item.stock} ${item.unit}',
                                      style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: expiryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item.expiredInfo,
                                  style: TextStyle(
                                    color: expiryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillTab({
    required IconData icon,
    required String label,
    required String categoryKey,
  }) {
    final isActive = activeCategory == categoryKey;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeCategory = categoryKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0F9F68) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF0F9F68)
                  : const Color(0xFFE5E7EB),
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF0F9F68).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                  fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
