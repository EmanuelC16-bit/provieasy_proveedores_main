import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provieasy_proveedores_main/config.dart';
import 'package:provieasy_proveedores_main/exceptions/proviesy_backend_exceptions.dart';

class ListApiResponse<T> {
  final List<T> items;
  final int totalCount;

  ListApiResponse({required this.items, required this.totalCount});
}


class ProvieasyBaseService {
  static Future<Map<String, dynamic>> _callApiRaw(String body, int spectedCode, {Map<String, String>? headers, Encoding? encoding, int timeOutSeconds=10}) async {
    try {
      final resp = await http.post(
            Config.baseUri,
            headers: headers,
            body: body,
            encoding: encoding,
          )
          .timeout(Duration(seconds: timeOutSeconds));
        if (resp.statusCode != 200) {
          throw ProvieasyBackendUnhandledException(statusCode:resp.statusCode);
        }
        final Map<String, dynamic> decoded =
            jsonDecode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
        if (decoded['code'] != spectedCode) {
          throw ProvieasyBackendHandledException(statusCode:decoded['code'], message:decoded['data']['error']);
        }
        return decoded;
    } on TimeoutException catch (e) {
      throw  ProvieasyBackendUnhandledException(statusCode: 500, details:'Request timed out: $e');
    } catch (e) {
      throw  ProvieasyBackendUnhandledException(statusCode: 500, details:'Request failed: $e');
    }
  }

  static Future<Map<String, dynamic>> callApiWithoutToken(String resolver, List<String> selectionSetList, Map<String, Object> arguments, int spectedCode) async {
     final body = jsonEncode({
      'resolve': resolver,
      'selectionSetList': selectionSetList,
      'arguments': arguments,
    });

    return _callApiRaw(body, spectedCode, headers:{"Content-Type": "application/json"});
  }
  
  static Future<Map<String, dynamic>> callApi(BuildContext context, String resolver, List<String> selectionSetList, Map<String, Object> arguments, int spectedCode) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'resolve': resolver,
      'selectionSetList': selectionSetList,
      'arguments': arguments,
    });

    return _callApiRaw(body, spectedCode, headers:headers);
  }

  static Future<ListApiResponse<dynamic>> callListApi(
    BuildContext context,
    String resolver,
    List<String> selectionSetList,
    Map<String, Object> arguments,
    int expectedCode,
  ) async {
    final decoded = await callApi(context, resolver, selectionSetList, arguments, expectedCode);
    final data = decoded['data'];

    if (data == null || data['items'] is! List || data['totalCount'] is! int) {
      throw ProvieasyBackendHandledException(
        statusCode: expectedCode,
        message: 'Unexpected data format: $data',
      );
    }

    return ListApiResponse(
      items: data['items'],
      totalCount: data['totalCount'],
    );
  }

  static Future<dynamic> callGetOneApi(BuildContext context, String resolver, List<String> selectionSetList, Map<String, Object> arguments, int spectedCode) async {
    final decoded = await callApi(context, resolver, selectionSetList, arguments, spectedCode);
    final dynamic rawData = decoded['data'];

    return rawData;
  }
}
