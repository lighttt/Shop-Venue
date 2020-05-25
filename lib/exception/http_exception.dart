class HttpException implements Exception {
  final message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
