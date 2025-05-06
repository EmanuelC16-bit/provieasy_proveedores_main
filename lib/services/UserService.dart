import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:provieasy_main_version/pages/login_page.dart';
import 'package:provieasy_proveedores_main/AuthStorage.dart';
import 'package:provieasy_proveedores_main/config.dart' show Config;
import 'package:provieasy_proveedores_main/main.dart' show LoginScreen;


bool isMyTokenExpired(String token) {
  final payload = JwtDecoder.decode(token);
  final exp = payload['e'];
  if (exp is int) {
    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiry);
  }
  return true;
}

class UserService {
  static Future<Map<String, dynamic>> fetchUserDetails(BuildContext ctx) async {
    final token = await AuthStorage.token;
    if (token == null) {
      _goToLogin(ctx);
      throw Exception('No token, please log in.');
    }

    if (isMyTokenExpired(token)) {
      await AuthStorage.clear();
      _goToLogin(ctx);
      throw Exception('Session expired, please log in again.');
    }

    final tokenType = await AuthStorage.tokenType;
    final headers = {
      'Content-Type': 'application/json',
      if (tokenType != null) 'Authorization': '$tokenType $token',
    };

    final userId = await AuthStorage.userId;
    if (userId == null) {
      throw Exception('No user_id found in storage.');
    }

    final response = await http.post(
      Config.baseUri,
      headers: headers,
      body: jsonEncode({
        'resolve': 'GetUser',
        'selectionSetList': [
          'user_id',
          'name',
          'email',
          'phone',
          'role',
        ],
        'arguments': {
          'user_id': userId,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['code'] != 200 || body['data'] == null) {
      throw Exception('Error from server: ${body['detail']}');
    }

    return body['data'] as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateUser(
      {required BuildContext context,
      required String userId,
      required String name,
      required String email,
      required String phone}) async {
    final resp = await http.post(
      Uri.parse('${Config.baseUrl}/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'resolve': 'UpdateUser',
        'selectionSetList': ['user_id', 'name', 'email', 'phone', 'role'],
        'arguments': {
          'user_id': userId,
          'name': name,
          'email': email,
          'phone': phone
        },
      }),
    );
    final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
    if (resp.statusCode != 200 || decoded['code'] != 200) {
      final detail = decoded['detail'] ?? 'Failed to update profile';
      // show a dialog or throw
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Update Failed'),
          content: Text(detail),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            )
          ],
        ),
      );
      throw Exception(detail);
    }
    return decoded['data'] as Map<String, dynamic>;
  }

  static void _goToLogin(BuildContext ctx) {
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }
}
