import '../data/models/inventory_item.dart';
import 'api_client.dart';

class InventoryService {
  static Future<List<InventoryItem>> list({String? category}) async {
    final data = await ApiClient.get(
      '/inventory',
      query: category != null ? {'category': category} : null,
    );
    return (data as List)
        .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<InventoryItem> create({
    required String name,
    required String icon,
    required int stock,
    required String unit,
    required DateTime expiredAt,
    required String category,
  }) async {
    final data = await ApiClient.post('/inventory', body: {
      'name': name,
      'icon': icon,
      'stock': stock,
      'unit': unit,
      'expired_at':
          '${expiredAt.year.toString().padLeft(4, '0')}-${expiredAt.month.toString().padLeft(2, '0')}-${expiredAt.day.toString().padLeft(2, '0')}',
      'category': category,
    });
    return InventoryItem.fromJson(data as Map<String, dynamic>);
  }
}
