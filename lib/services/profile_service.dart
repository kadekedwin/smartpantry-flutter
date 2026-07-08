import '../models/user.dart';
import 'api_client.dart';

class ProfileService {
  static Future<User> get() async {
    final data = await ApiClient.get('/profile');
    return User.fromJson(data as Map<String, dynamic>);
  }
}
