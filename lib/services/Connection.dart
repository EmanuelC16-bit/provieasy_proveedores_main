import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provieasy_proveedores_main/AuthStorage.dart';
import 'package:provieasy_proveedores_main/config.dart';
// import 'package:provieasy_proveedores_main/Pages/HomePage.dart';
// import 'package:provieasy_proveedores_main/Pages/HomePage_test.dart';
import 'package:provieasy_proveedores_main/services/NotificationService.dart' show NotificationService;

import '../pages/HomePage_test.dart';
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

  // final responseUsrRole = await http.post(
  //     uri,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       'resolve': 'GetUser',
  //       'selectionSetList': ['role'],
  //       'arguments': {'email': email},
  //     }),
  //   );

    // final data2 = jsonDecode(responseUsrRole.body);
    // final rawData = data2['data'] as Map<String, dynamic>;
    // var role = 0;
    
    // try{
    //   role = rawData['role'] as int;
    // } catch (error){
    //    Exception(error);
    // }


    // // a213100440@ceti.mx
    
    // print(data2);
    // print(role);

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
      // final providerId = payload['u'] as String;
      // await AuthStorage.saveProviderId(providerId);
      // // await AuthStorage.saveUserRole(payload['r'] as String);
      final exp = payload['e'] as int;
      final role = payload['r'] as int;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      await AuthStorage.saveTokenExpiry(expiry.toIso8601String());

      logger.d("Login successful: $token");
      await NotificationService.showNotification(
        title: "Welcome back!",
        body: "You're now logged in to ProvyEasy.",
      );

      // Navigate to home, replacing login
      // ignore: use_build_context_synchronously
      if(role == 2){
      Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => ProviderHomePage(),),);
      } else{_showErrorDialog(context, "User is not a provider");}
    } else {
      // _showErrorDialog(context, data['detail']);
    }
  } else {
    final error = jsonDecode(response.body);
    _showErrorDialog(context, error['detail'] ?? 'Network Error');
  }
}

Future<Map<String, dynamic>> GetContracts() async { 
  final String? userId = await AuthStorage.userId; 
  final uri = Uri.parse('${Config.baseUrl}/');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "resolve": "GetContracts",  
      "selectionSetList": ["contract_id",
        "provider_name",
        "provider_id",
        "status",
        "request_date"],
          "arguments": {
            "offset": 0,
            "status": 1,
            "provider_id": userId,
            "order": "desc"
          }
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final status = data['code'];

    print(data);

    if (status == 200 && data['data'] != null) {
      return jsonDecode(response.body);
      // await NotificationService.showNotification(
      //   title: "Account created!",
      //   body: "Your account has been created successfully.",
      // );

      // Navigator.pushReplacementNamed(context, '/login');
    } else {
      // _showErrorDialog(context, data['detail']);
      throw Exception('Failed to load contracts');
    }
  } else {
    // final error = jsonDecode(response.body);
    throw Exception('Failed to load contracts');
    // _showErrorDialog(context, error['detail'] ?? 'Network Error');
  }
}

Future<Map<String, dynamic>> GetContract(String contractId) async { 
  final uri = Uri.parse('${Config.baseUrl}/');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "resolve": "GetContract",
      "selectionSetList": [
        "contract_id",
        "client_id",
        "status",
        "request_date", 
        "contract_service/agreed_price",
        "contract_service/user_request",
        "contract_service/location_service",
        "rating",
        "contract_review/comment",
        "contract_details/detail",
        "contract_details/price"
      ],
      "arguments": {
        "contract_id": contractId
      }
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final status = data['code'];

    if (status == 200 && data['data'] != null) {
      return data;
    } else {
      throw Exception('Failed to load contract details');
    }
  } else {
    throw Exception('Failed to load contract details');
  }
}

Future<void> GetProvider(
  // BuildContext context, String userName, String email,
    // String password, String phoneNumber
    ) async {
  final uri = Uri.parse('${Config.baseUrl}/');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "resolve": "GetContracts",  
      "selectionSetList": ["contract_id",
        "provider_name",
        "provider_id",
        "status",
        "request_date"],
          "arguments": {
            "offset": 0,
        
            "order": "desc"
          }
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final status = data['code'];

    print(data);

    if (status == 200 && data['data'] != null) {
      await NotificationService.showNotification(
        title: "Account created!",
        body: "Your account has been created successfully.",
      );

      // Navigator.pushReplacementNamed(context, '/login');
    } else {
      // _showErrorDialog(context, data['detail']);
    }
  } else {
    // final error = jsonDecode(response.body);
    // _showErrorDialog(context, error['detail'] ?? 'Network Error');
  }
}

Future<void> UpdateContract(String contractId, double agreedPrice) async {
  final uri = Uri.parse('${Config.baseUrl}/');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
    //   "resolve": "UpdateContractDetail",
    //   "selectionSetList": ["contract_detail_id", "contract_id", "detail", "price"],
    //   "arguments":  {
    //       "contract_id": contractId,
          
    //       "price": agreedPrice
    // }
    "resolve": "UpdateContract",
    "selectionSetList": ["contract_id", "client_id", "status", "contract_service/agreed_price", "contract_service/user_request", "contract_service/location_service"],
    "arguments":  {
        "contract_id": contractId,
        // "client_id": "a260482c-9011-483b-aaeb-c61ab8b376a1",
        // "token_signature_provider": "token_provider_signature",
        "status": 2,
        "contract_service": {
            "agreed_price": agreedPrice
        }
    }
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final status = data['code'];

    if (status == 200 && data['data'] != null) {
      return data;
    } else {
      throw Exception('Failed to load contract details');
    }
  } else {
    throw Exception('Failed to load contract details');
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