import 'package:flutter/material.dart';
import '../../../data/models/shopping_item.dart';
import '../../../services/api_client.dart';
import '../../../services/inventory_service.dart';
import '../../../services/shopping_service.dart';
import '../shopping_list_item.dart';
import 'add_shopping_sheet.dart';
import 'move_to_inventory_sheet.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  late Future<List<ShoppingItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = ShoppingService.list();
  }

  void _reload() {
    setState(() {
      _future = ShoppingService.list();
    });
  }

  Future<void> _toggle(ShoppingItem item) async {
    final result = await showModalBottomSheet<MoveToInventoryResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => MoveToInventorySheet(item: item),
    );
    if (result == null) return;
    try {
      await InventoryService.create(
        name: item.name,
        imageFile: result.imageFile,
        stock: item.quantity.round().clamp(1, 1 << 30),
        unit: item.unit,
        expiredAt: result.expiredAt,
        category: result.category,
      );
      await ShoppingService.toggle(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dipindahkan ke inventory'),
          backgroundColor: Color(0xFF0F9F68),
        ),
      );
      _reload();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal (${e.statusCode}): ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memindahkan: $e')));
    }
  }

  Future<void> _showAddDialog() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddShoppingSheet(),
    );
    if (result == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: FutureBuilder<List<ShoppingItem>>(
        future: _future,
        builder: (context, snapshot) {
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
                  Text(msg),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _reload,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }
          final items = snapshot.data ?? [];
          final notBought = items.where((e) => !e.isBought).toList();
          final bought = items.where((e) => e.isBought).toList();
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                Text(
                  'BELUM DIBELI (${notBought.length})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...notBought.map(
                  (item) => ShoppingListItem(
                    item: item,
                    onToggle: () => _toggle(item),
                  ),
                ),
                if (bought.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'SUDAH DIBELI (${bought.length})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...bought.map((item) => ShoppingListItem(item: item)),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF0F9F68),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
