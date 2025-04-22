class AppException implements Exception{
  final Object? error;

  AppException(this.error);
}