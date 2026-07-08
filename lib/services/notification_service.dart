import '../models/notification_item.dart';
import 'api_client.dart';

class NotificationService {
  static Future<List<NotificationItem>> list() async {
    final data = await ApiClient.get('/notifications');
    return (data as List)
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
