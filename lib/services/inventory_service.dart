import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../data/models/inventory_item.dart';
import 'api_client.dart';

class InventoryService {
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

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
    required File imageFile,
    required int stock,
    required String unit,
    required DateTime expiredAt,
    required String category,
  }) async {
    final form = FormData.fromMap({
      'name': name,
      'stock': stock.toString(),
      'unit': unit,
      'expired_at':
          '${expiredAt.year.toString().padLeft(4, '0')}-${expiredAt.month.toString().padLeft(2, '0')}-${expiredAt.day.toString().padLeft(2, '0')}',
      'category': category,
      'image': await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.uri.pathSegments.last),
    });
    final data = await ApiClient.postForm('/inventory', form);
    final item = InventoryItem.fromJson(data as Map<String, dynamic>);
    revision.value++;
    return item;
  }
}
