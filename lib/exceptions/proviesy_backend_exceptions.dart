/// Base interface for all exceptions coming from the Provieasy backend.
/// 
/// All backend-related exceptions in the app should implement this
/// to allow unified error handling.
abstract class ProvieasyBackendException implements Exception {}

/// Exception representing **unhandled backend errors**, such as:
/// - Network timeouts
/// - Unexpected response formats (decoding errors)
/// - Server issues we did not anticipate
/// 
/// These are general backend failures outside the app’s direct control.
class ProvieasyBackendUnhandledException implements ProvieasyBackendException {
  /// The HTTP status code returned (if available).
  final int statusCode;

  /// Optional details about the error (e.g., raw response, error body).
  final String? details;

  ProvieasyBackendUnhandledException({
    required this.statusCode,
    this.details,
  });

  @override
  String toString() =>
      'ProvieasyBackendUnhandledException: [$statusCode] ${details ?? ""}';
}

/// Exception representing **handled backend errors**, meaning:
/// - The app sent something invalid (bad request, wrong data)
/// - The server failed to process the request due to logic or validation errors
/// - Any known backend issue we want to explicitly handle
/// 
/// These are errors where the app or server knows **what went wrong**
/// and we can show meaningful feedback to the user.
class ProvieasyBackendHandledException implements ProvieasyBackendException {
  /// The HTTP status code returned.
  final int statusCode;

  /// A short message describing the error.
  final String message;

  /// Optional detailed information (e.g., error body, debug info).
  final String? details;

  ProvieasyBackendHandledException({
    required this.statusCode,
    required this.message,
    this.details,
  });

  @override
  String toString() =>
      'ProvieasyBackendHandledException: [$statusCode] $message ${details ?? ""}';
}
