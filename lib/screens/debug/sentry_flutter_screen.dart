import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryFlutterScreen extends StatefulWidget {
  @override
  _SentryFlutterScreenState createState() => _SentryFlutterScreenState();
}

class _SentryFlutterScreenState extends State<SentryFlutterScreen> {

  bool _loading = false;

  bool _captureExceptionSuccess = false;
  String _captureExceptionFailure;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentry Flutter SDK - Debug'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Sentry.captureException Exception',
                style: TextStyle(color: Colors.black)
              ),
              subtitle: Text(
                  _captureExceptionSuccess
                      ? 'Success'
                      : _captureExceptionFailure != null
                        ? 'Failure: $_captureExceptionFailure'
                        : '--'
              ),
              trailing: RaisedButton(
                child: _loading ? Text('Loading...') : Text('Send'),
                onPressed: _loading ? null : _captureException,
              ),
            )
          ],
        ),
      )
    );
  }

  void _captureException() {
    setState(() {
      _loading = true;
    });
    try {
      throw Exception('Sentry.captureException operatingSystem: ${Platform.operatingSystem}');
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace)
          .then((value) => {
            setState(() {
              _loading = false;
              _captureExceptionSuccess = true;
            })
          })
          .catchError((error) => {
            setState(() {
              _loading = false;
              _captureExceptionFailure = Error.safeToString(error);
            })
          });
    }
  }
}