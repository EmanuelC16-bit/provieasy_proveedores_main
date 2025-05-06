import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provieasy_proveedores_main/AuthStorage.dart';
import 'package:provieasy_proveedores_main/config.dart';
import 'package:provieasy_proveedores_main/services/NotificationService.dart' show NotificationService;
// import 'package:provieasy_main_version/AuthStorage.dart';
// import 'package:provieasy_main_version/services/NotificationService.dart';
// import 'package:provieasy_main_version/config.dart';

var logger = Logger();

Future<void> performLogin(
    BuildContext context, String email, String password) async {
  final uri = Uri.parse('${Config.baseUrl}/');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'resolve': 'Login',
      'selectionSetList': ['token', 'token_type'],
      'arguments': {
        'email': email,
        'password': password,
      }
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final status = data['code'];

    if (status == 200 && data['data'] != null) {
      final rawData = data['data'] as Map<String, dynamic>;
      final tokenType = rawData['token_type'] as String;
      final token = rawData['token'] as String;

      // Persist token and decode claims
      await AuthStorage.saveToken(tokenType: tokenType, token: token);
      final payload = JwtDecoder.decode(token);
      await AuthStorage.saveUserId(payload['u'] as String);
      await AuthStorage.saveUserRole(payload['r'] as String);
      final exp = payload['e'] as int;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      await AuthStorage.saveTokenExpiry(expiry.toIso8601String());

      logger.d("Login successful: $token");
      await NotificationService.showNotification(
        title: "Welcome back!",
        body: "You're now logged in to ProvyEasy.",
      );

      // Navigate to home, replacing login
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showErrorDialog(context, data['detail']);
    }
  } else {
    final error = jsonDecode(response.body);
    _showErrorDialog(context, error['detail'] ?? 'Network Error');
  }
}

Future<void> createUser(BuildContext context, String userName, String email,
    String password, String phoneNumber) async {
  final uri = Uri.parse('${Config.baseUrl}/');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'resolve': 'CreateUser',
      'selectionSetList': [],
      'arguments': {
        'name': userName,
        'email': email,
        'role': 'client',
        'phone': phoneNumber,
        'password': password,
      }
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final status = data['code'];

    if (status == 200 && data['data'] != null) {
      await NotificationService.showNotification(
        title: "Account created!",
        body: "Your account has been created successfully.",
      );

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _showErrorDialog(context, data['detail']);
    }
  } else {
    final error = jsonDecode(response.body);
    _showErrorDialog(context, error['detail'] ?? 'Network Error');
  }
}

void _showErrorDialog(BuildContext ctx, String message) {
  showDialog(
    context: ctx,
    builder: (_) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(ctx).pop(),
        ),
      ],
    ),
  );
}
