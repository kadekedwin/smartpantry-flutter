import '../models/shopping_item.dart';
import 'api_client.dart';

class ShoppingService {
  static Future<List<ShoppingItem>> list() async {
    final data = await ApiClient.get('/shopping');
    return (data as List)
        .map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<ShoppingItem> create({
    required String name,
    required double quantity,
    required String unit,
  }) async {
    final data = await ApiClient.post('/shopping', body: {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    });
    return ShoppingItem.fromJson(data as Map<String, dynamic>);
  }

  static Future<void> toggle(String id) async {
    await ApiClient.patch('/shopping/$id/toggle');
  }
}
