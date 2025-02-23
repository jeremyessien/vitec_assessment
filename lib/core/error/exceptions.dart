class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
}

class ApiException implements Exception {
  final String message;
  final dynamic error;

  ApiException({
    required this.message,
    this.error,
  });

  @override
  String toString() => 'ApiException: $message${error != null ? ' ($error)' : ''}';
}