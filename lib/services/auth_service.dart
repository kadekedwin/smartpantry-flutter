import '../models/user.dart';
import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  static Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await ApiClient.post(
      '/auth/register',
      auth: false,
      body: {'name': name, 'email': email, 'password': password},
    );
    await TokenStorage.save(data['token'] as String);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  static Future<User> login({
    required String email,
    required String password,
  }) async {
    final data = await ApiClient.post(
      '/auth/login',
      auth: false,
      body: {'email': email, 'password': password},
    );
    await TokenStorage.save(data['token'] as String);
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  static Future<void> logout() async {
    try {
      await ApiClient.post('/auth/logout');
    } finally {
      await TokenStorage.clear();
    }
  }
}
