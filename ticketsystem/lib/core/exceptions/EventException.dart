class EventException implements Exception {
  final int statusCode;
  final String message;

  EventException(this.statusCode, this.message);

  @override
  String toString() => message;
}