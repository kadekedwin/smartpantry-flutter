import 'package:flutter/material.dart';
import '../../data/models/inventory_item.dart';
import '../../services/inventory_service.dart';
import '../components/tab_header.dart';
import '../components/tabs/inventory_body.dart';
import '../components/tabs/inventory_category_pill.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: FutureBuilder<List<InventoryItem>>(
        future: _future,
        builder: (context, snapshot) {
          final items = snapshot.data ?? const <InventoryItem>[];
          final filtered = items
              .where((item) => item.category == activeCategory)
              .toList();

          return Column(
            children: [
              const TabHeader(title: 'Inventory', subtitle: 'Stok saya'),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    InventoryCategoryPill(
                      icon: Icons.kitchen_rounded,
                      label: 'Kulkas',
                      categoryKey: 'kulkas',
                      activeCategory: activeCategory,
                      onTap: (key) => setState(() => activeCategory = key),
                    ),
                    const SizedBox(width: 8),
                    InventoryCategoryPill(
                      icon: Icons.ac_unit_rounded,
                      label: 'Freezer',
                      categoryKey: 'freezer',
                      activeCategory: activeCategory,
                      onTap: (key) => setState(() => activeCategory = key),
                    ),
                    const SizedBox(width: 8),
                    InventoryCategoryPill(
                      icon: Icons.layers_rounded,
                      label: 'Rak Dapur',
                      categoryKey: 'rak_dapur',
                      activeCategory: activeCategory,
                      onTap: (key) => setState(() => activeCategory = key),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: InventoryBody(
                  snapshot: snapshot,
                  filtered: filtered,
                  onRefresh: () async => _reload(),
                  onRetry: _reload,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
