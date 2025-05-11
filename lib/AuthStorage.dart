import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthStorage {
  static const _store = FlutterSecureStorage();
  static const _keyProviderId = 'provider_id';


  static Future<void> saveProviderId(String providerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProviderId, providerId);
  }

  // static Future<String?> getProviderId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_keyProviderId);
  // }

  static Future<void> saveToken({
    required String tokenType,
    required String token,
  }) async {
    await _store.write(key: 'token_type', value: tokenType);
    await _store.write(key: 'token', value: token);
  }


  static Future<void> saveUserId(String id) async =>
      await _store.write(key: 'user_id', value: id);

  static Future<void> saveUserRole(String role) async =>
      await _store.write(key: 'user_role', value: role);

  static Future<void> saveTokenExpiry(String iso) async =>
      await _store.write(key: 'token_expiry', value: iso);

  static Future<String?> get tokenType async =>
      await _store.read(key: 'token_type');

  static Future<void> saveUserProfile(String json) =>
      _store.write(key: 'user_profile', value: json);

  static Future<String?> get userProfileJson async =>
      _store.read(key: 'user_profile');

  static Future<String?> get token async => await _store.read(key: 'token');

  static Future<String?> get userId async => _store.read(key: 'user_id');

  static Future<String?> get userRole async => _store.read(key: 'user_role');

  static Future<DateTime?> get tokenExpiry async {
    final expiry = await _store.read(key: 'token_expiry');
    return expiry == null ? null : DateTime.parse(expiry);
  }

  static Future<void> clear() async {
    await _store.deleteAll();
  }
}
