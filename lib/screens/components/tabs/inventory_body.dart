import 'package:flutter/material.dart';
import '../../../data/models/inventory_item.dart';
import '../../../services/api_client.dart';
import 'inventory_card.dart';

class InventoryBody extends StatelessWidget {
  final AsyncSnapshot<List<InventoryItem>> snapshot;
  final List<InventoryItem> filtered;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  const InventoryBody({
    super.key,
    required this.snapshot,
    required this.filtered,
    required this.onRefresh,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
            TextButton(onPressed: onRetry, child: const Text('Coba lagi')),
          ],
        ),
      );
    }
    if (filtered.isEmpty) {
      return const Center(child: Text('Tidak ada barang di kategori ini'));
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, index) => InventoryCard(item: filtered[index]),
      ),
    );
  }
}
