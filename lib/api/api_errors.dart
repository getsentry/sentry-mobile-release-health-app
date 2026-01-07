class ApiError extends Error {
  ApiError(this.statusCode, this.message);

  final int statusCode;
  final String message;

  /// Returns true if this error indicates the user needs to re-authenticate.
  /// This happens when the access token is expired, revoked, or invalid.
  bool get isAuthenticationError => statusCode == 401;

  @override
  String toString() {
    return 'api error statusCode: $statusCode message: ${Error.safeToString(message)}';
  }
}
