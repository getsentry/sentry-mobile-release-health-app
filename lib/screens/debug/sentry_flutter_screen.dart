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

  final _successResults = {
    _TypeToThrow.EXCEPTION: false,
    _TypeToThrow.ERROR: false,
    _TypeToThrow.STRING: false,
  };

  final Map<_TypeToThrow, String> _failureResults = {
    _TypeToThrow.EXCEPTION: null,
    _TypeToThrow.ERROR: null,
    _TypeToThrow.STRING: null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentry Flutter SDK - Debug'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _createListTile(_TypeToThrow.EXCEPTION),
            _createListTile(_TypeToThrow.ERROR),
            _createListTile(_TypeToThrow.STRING)
          ],
        ),
      )
    );
  }

  Widget _createListTile(_TypeToThrow typeToThrow) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Sentry.captureException',
              style: TextStyle(color: Colors.black)
          ),
          Text(
              '${typeToThrow.name()} Instance',
              style: TextStyle(color: Colors.deepPurpleAccent)
          ),
        ],
      ),
      subtitle: Text(
          _successResults[typeToThrow]
              ? 'Success'
              : _failureResults[typeToThrow] != null
              ? 'Failure: ${_failureResults[typeToThrow]}'
              : '--'
      ),
      trailing: RaisedButton(
        child: _loading ? Text('Loading...') : Text('Send'),
        onPressed: _loading ? null : () => _captureException(typeToThrow),
      ),
    );
  }

  void _captureException(_TypeToThrow typeToThrow) {
    setState(() {
      _loading = true;
    });
    try {
      switch(typeToThrow) {
        case _TypeToThrow.EXCEPTION:
          throw Exception('Sentry.captureException - ${typeToThrow.name()} Instance - operatingSystem: ${Platform.operatingSystem}');
          break;
        case _TypeToThrow.ERROR:
          throw _SampleError('Sentry.captureException - ${typeToThrow.name()} Instance - operatingSystem: ${Platform.operatingSystem}');
          break;
        case _TypeToThrow.STRING:
          throw 'Sentry.captureException - ${typeToThrow.name()} Instance - operatingSystem: ${Platform.operatingSystem}';
          break;
      }
      
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace)
          .then((value) => {
            setState(() {
              _loading = false;
              _successResults[typeToThrow] = true;
            })
          })
          .catchError((error) => {
            setState(() {
              _loading = false;
              _failureResults[typeToThrow] = Error.safeToString(error);
            })
          });
    }
  }
}

enum _TypeToThrow {
  EXCEPTION, ERROR, STRING
}

extension _TypeToThrowPrint on _TypeToThrow {
  String name() {
    switch(this) {
      case _TypeToThrow.EXCEPTION:
        return 'Exception';
        break;
      case _TypeToThrow.ERROR:
        return 'Error';
        break;
      case _TypeToThrow.STRING:
        return 'String';
        break;
    }
  }
}

class _SampleError extends Error {
  _SampleError(this.message);

  final Object message;

  @override
  String toString() {
    return message != null
        ? 'json error: ${Error.safeToString(message)}'
        : 'Unknown json error';
  }
}

