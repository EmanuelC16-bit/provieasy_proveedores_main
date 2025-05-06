import 'dart:io' show Platform;

class Config {
  static const _envApiUrl = String.fromEnvironment('API_URL', defaultValue: '');
  static String? _cachedBaseUrl;
  
  static String get baseUrl {
    if (_cachedBaseUrl != null) {
      return _cachedBaseUrl!;
    }

    String resolvedUrl;
    if (_envApiUrl.isNotEmpty) {
      resolvedUrl = _envApiUrl;
    } else if (Platform.isAndroid) {
      resolvedUrl = 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      resolvedUrl = 'http://192.168.100.10:8000';
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      resolvedUrl = 'http://localhost:8000';
    } else {
      resolvedUrl = 'http://localhost:8000';
    }

    _cachedBaseUrl = resolvedUrl;
    return resolvedUrl;
  }

  static Uri get baseUri {
    return Uri.parse('${Config.baseUrl}/');
  }
}
