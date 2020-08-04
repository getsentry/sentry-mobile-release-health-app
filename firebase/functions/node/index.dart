import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_functions_interop/firebase_functions_interop.dart';

void main() {
  final config = functions.config;
  final key = config.get('key') as String;
  if (key == null) {
    throw Exception('No key to verify signature in config.');
  }

  final keyBytes = utf8.encode(key);
  final hmac = Hmac(sha256, keyBytes);

  functions['alert'] = functions.https.onRequest((r) => handleAlert(r, hmac));
}

// https://docs.sentry.io/workflow/integrations/integration-platform/webhooks/#webhook-alerts
Future<void> handleAlert(ExpressHttpRequest request, Hmac hmac) async {
  try {
    if (!verifySignature(request, hmac)) {
      request.response.statusCode = 400;
    } else {
      request.response.statusCode = 200;

      // do stuff
    }
  } catch (e, s) {
    // Add Sentry
    print('$e\n$s');
  } finally {
    request.response.close();
  }
}

bool verifySignature(ExpressHttpRequest request, Hmac hmac) {
  const signatureHeaderKey = 'Sentry-Hook-Signature';
  final signatureHeader = request.headers[signatureHeaderKey];

  if (signatureHeader?.length != 1) {
    throw Exception('Request contains invalid $signatureHeaderKey.');
  }

  final jsonBody = JsonEncoder().convert(request.body);
  final messageBytes = utf8.encode(jsonBody);
  final actualDigest = hmac.convert(messageBytes);

  return signatureHeader.single == actualDigest.toString();
}
