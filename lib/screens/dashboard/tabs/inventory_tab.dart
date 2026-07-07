import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../../../data/models/inventory_item.dart';
import '../../../services/inventory_service.dart';
import '../../../services/api_client.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  String activeCategory = 'kulkas';
  late Future<List<InventoryItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = InventoryService.list();
    InventoryService.revision.addListener(_onExternalChange);
  }

  @override
  void dispose() {
    InventoryService.revision.removeListener(_onExternalChange);
    super.dispose();
  }

  void _onExternalChange() {
    if (mounted) _reload();
  }

  void _reload() {
    setState(() {
      _future = InventoryService.list();
    });
  }

  Color _getExpiryColor(DateTime expiredAt) {
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    final e = DateTime(expiredAt.year, expiredAt.month, expiredAt.day);
    final days = e.difference(t).inDays;
    if (days <= 2) return const Color(0xFFEF4444);
    if (days <= 5) return const Color(0xFFF59E0B);
    return const Color(0xFF0F9F68);
  }

  int _countByCategory(List<InventoryItem> items, String category) =>
      items.where((e) => e.category == category).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: FutureBuilder<List<InventoryItem>>(
        future: _future,
        builder: (context, snapshot) {
          final items = snapshot.data ?? const <InventoryItem>[];
          final filtered =
              items.where((item) => item.category == activeCategory).toList();

          return Column(
            children: [
              HeaderInventoryView(
                title: 'Inventory',
                subtitle: 'Stok saya',
                stats: [
                  HeaderStat(
                    label: 'Kulkas',
                    value: '${_countByCategory(items, 'kulkas')}',
                  ),
                  HeaderStat(
                    label: 'Freezer',
                    value: '${_countByCategory(items, 'freezer')}',
                  ),
                  HeaderStat(
                    label: 'Rak Dapur',
                    value: '${_countByCategory(items, 'rak_dapur')}',
                  ),
                ],
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
              Expanded(child: _buildBody(snapshot, filtered)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    AsyncSnapshot<List<InventoryItem>> snapshot,
    List<InventoryItem> filtered,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      final err = snapshot.error;
      final msg = err is ApiException
          ? err.message
          : 'Tidak dapat terhubung ke server';
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: _reload, child: const Text('Coba lagi')),
          ],
        ),
      );
    }
    if (filtered.isEmpty) {
      return const Center(child: Text('Tidak ada barang di kategori ini'));
    }
    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final item = filtered[index];
          return _buildInventoryCard(item);
        },
      ),
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    final expiryColor = _getExpiryColor(item.expiredAt);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.image.isEmpty
                  ? const Center(
                      child: Icon(Icons.image_outlined,
                          size: 40, color: Color(0xFF9CA3AF)),
                    )
                  : Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.broken_image_outlined,
                            size: 32, color: Color(0xFF9CA3AF)),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.stock} ${item.unit}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: expiryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.expiredInfo,
                    style: TextStyle(
                      color: expiryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
