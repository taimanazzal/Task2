class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  NoInternetException() : super('لا يوجد اتصال بالإنترنت');
}

class TimeoutException extends ApiException {
  TimeoutException() : super('انتهت مهلة الاتصال، حاول مرة أخرى');
}

class ServerException extends ApiException {
  ServerException(int statusCode)
    : super('حدث خطأ في الخادم (كود $statusCode)');
}
