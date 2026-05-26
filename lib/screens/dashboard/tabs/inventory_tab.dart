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

  @override
  Widget build(BuildContext context) {
    List<InventoryItem> filteredData = dummyInventoryData
        .where((item) => item.category == activeCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          HeaderInventoryView(title: 'Inventory', subtitle: 'Stok saya'),

          // 3. KOMPONEN SEARCH
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 8, 12),
            child: SearchBarView(),
          ),

          // 4. TABS NAVIGATION (Kulkas, Freezer, Rak Dapur)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(
                  icon: Icons.kitchen,
                  label: 'Kulkas',
                  categoryKey: 'kulkas',
                ),
                _buildTabItem(
                  icon: Icons.ac_unit,
                  label: 'Freezer',
                  categoryKey: 'freezer',
                ),
                _buildTabItem(
                  icon: Icons.layers,
                  label: 'Rak Dapur',
                  categoryKey: 'rak_dapur',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. DAFTAR BARANG YANG SUDAH DIFILTER
          Expanded(
            child: filteredData.isEmpty
                ? const Center(child: Text('Tidak ada barang di kategori ini'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final item = filteredData[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              item.icon,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Stok: ${item.stock} ${item.unit}\n${item.expiredInfo}',
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Helper function untuk membangun widget tab item secara dinamis
  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required String categoryKey,
  }) {
    bool isActive = activeCategory == categoryKey;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeCategory = categoryKey;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFF0F9F68) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF0F9F68) : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? const Color(0xFF0F9F68) : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
