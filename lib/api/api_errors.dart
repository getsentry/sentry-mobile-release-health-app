class ApiError extends Error {
  ApiError(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() {
    return 'api error statusCode: $statusCode message: ${Error.safeToString(message)}';
  }
}
