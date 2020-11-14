class ApiError extends Error {
  ApiError(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() {
    return statusCode != null
        ? 'api error statusCode: $statusCode message: ${Error.safeToString(message)}'
        : 'Unknown json error';
  }
}

class JsonError extends Error {
  JsonError(this.message);

  final Object message;

  @override
  String toString() {
    return message != null
      ? 'json error: ${Error.safeToString(message)}'
      : 'Unknown json error';
  }
}