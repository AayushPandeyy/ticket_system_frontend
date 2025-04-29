class AuthException implements Exception {
  final int statusCode;
  final String message;

  AuthException(this.statusCode, this.message);

  @override
  String toString() => message;
}