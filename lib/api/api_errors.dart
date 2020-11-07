class ApiError extends Error {
  ApiError(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() {
    if (statusCode != null) {
      return 'api error statusCode: $statusCode message: ${Error.safeToString(message)}';
    }
    return 'Unknown json error';
  }
}

class JsonError extends Error {
  JsonError([this.message]);

  final Object message;

  @override
  String toString() {
    if (message != null) {
      return 'json error: ${Error.safeToString(message)}';
    }
    return 'Unknown json error';
  }
}