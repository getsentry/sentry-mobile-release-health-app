import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryFlutterScreen extends StatefulWidget {
  @override
  _SentryFlutterScreenState createState() => _SentryFlutterScreenState();
}

class _SentryFlutterScreenState extends State<SentryFlutterScreen> {
  static const platform = MethodChannel('app.sentrymobile.io/nativeCrash');
  bool _loading = false;

  var _successResultEvent = false;
  String _failureResultEvent;

  var _successResultMessage = false;
  String _failureResultMessage;

  final _successResultsHandled = {
    _TypeToThrow.EXCEPTION: false,
    _TypeToThrow.ERROR: false,
    _TypeToThrow.STRING: false,
  };

  final Map<_TypeToThrow, String> _failureResultsHandled = {
    _TypeToThrow.EXCEPTION: null,
    _TypeToThrow.ERROR: null,
    _TypeToThrow.STRING: null,
  };

  final _successResultsUnhandled = {
    _TypeToThrow.EXCEPTION: false,
    _TypeToThrow.ERROR: false,
    _TypeToThrow.STRING: false,
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentry Flutter SDK - Debug'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: Text('Event & Message', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            _createEventListTile(),
            _createMessageListTile(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: Text('Sentry.captureException', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            _createListTile('Sentry.captureException', _TypeToThrow.EXCEPTION),
            _createListTile('Sentry.captureException', _TypeToThrow.ERROR),
            _createListTile('Sentry.captureException', _TypeToThrow.STRING),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: Text('Throw Exception', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            _createListTile('Throw Exception', _TypeToThrow.EXCEPTION, fatal: true),
            _createListTile('Throw Exception', _TypeToThrow.ERROR, fatal: true),
            _createListTile('Throw Exception', _TypeToThrow.STRING, fatal: true),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: Text('Native', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            _createNativeListTile(_NativePlatform.Android, true),
            _createNativeListTile(_NativePlatform.Android, false),
            _createNativeListTile(_NativePlatform.iOS, true),
            _createNativeListTile(_NativePlatform.iOS, false)
          ],
        ),
      )
    );
  }

  Widget _createEventListTile() {
    var subtitle = _successResultEvent ? 'Success' : '--';
    if (_failureResultEvent != null) {
      subtitle = 'Failure: $_failureResultEvent';
    }
    return ListTile(
      title: Text(
          'Sentry.captureEvent',
          style: TextStyle(color: Colors.black)
      ),
      subtitle: Text(
          subtitle
      ),
      trailing: RaisedButton(
        child: _loading ? Text('Loading...') : Text('Send') ,
        onPressed: _loading ? null : () => _captureEvent(),
      )
    );
  }

  Widget _createMessageListTile() {
    var subtitle = _successResultMessage ? 'Success' : '--';
    if (_failureResultMessage != null) {
      subtitle = 'Failure: $_failureResultMessage';
    }
    return ListTile(
        title: Text(
            'Sentry.sendMessage',
            style: TextStyle(color: Colors.black)
        ),
        subtitle: Text(
            subtitle
        ),
        trailing: RaisedButton(
          child: _loading ? Text('Loading...') : Text('Send') ,
          onPressed: _loading ? null : () => _captureMessage(),
        )
    );
  }

  Widget _createListTile(String title, _TypeToThrow typeToThrow, {bool fatal = false}) {
    var subtitle = '';
    if (!fatal) {
      subtitle = _successResultsHandled[typeToThrow]
          ? 'Success'
          : _failureResultsHandled[typeToThrow] != null
            ? 'Failure: ${_failureResultsHandled[typeToThrow]}'
            : '--';
    } else {
      subtitle = _successResultsUnhandled[typeToThrow]
          ? 'Success'
          : '--';
    }

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title,
              style: TextStyle(color: Colors.black)
          ),
          Text(
              '${typeToThrow.name()} Instance',
              style: TextStyle(color: Colors.deepPurpleAccent)
          ),
        ],
      ),
      subtitle: Text(
          subtitle
      ),
      trailing: RaisedButton(
        child: _loading ? Text('Loading...') : fatal ? Text('Throw') : Text('Send'),
        onPressed: _loading ? null : () => _captureException(typeToThrow, fatal),
      ),
    );
  }

  Widget _createNativeListTile(_NativePlatform nativePlatform, bool primaryLanguage) {
    return ListTile(
      title: Text(
          nativePlatform == _NativePlatform.Android ? 'Android' : 'iOS',
          style: TextStyle(color: Colors.black)
      ),
      subtitle: Text(
          nativePlatform == _NativePlatform.Android
            ? primaryLanguage ? 'Kotlin' : 'Java'
            : primaryLanguage ? 'Swift' : 'Objective C',
          style: TextStyle(color: Colors.deepPurpleAccent)
      ),
      trailing: RaisedButton(
        child: Text('Crash!'),
        onPressed: () => _callCrashNative(nativePlatform, primaryLanguage),
      ),
    );
  }

  void _captureEvent() {
    setState(() {
      _loading = true;
    });
    final event = SentryEvent(message: Message('Sentry.captureEvent'));
    Sentry.captureEvent(event)
        .then((value) => {
      setState(() {
        _loading = false;
        _successResultEvent = true;
      })
    })
        .catchError((error) => {
      setState(() {
        _loading = false;
        _failureResultEvent = Error.safeToString(error);
      })
    });
  }

  void _captureMessage() {
    setState(() {
      _loading = true;
    });
    Sentry.captureMessage('Sentry.captureMessage')
        .then((value) => {
      setState(() {
        _loading = false;
        _successResultMessage = true;
      })
    })
        .catchError((error) => {
      setState(() {
        _loading = false;
        _failureResultMessage = Error.safeToString(error);
      })
    });
  }

  void _captureException(_TypeToThrow typeToThrow, bool fatal) {
    setState(() {
      _loading = !fatal;
    });

    final title = fatal ? 'Unhandled Exception' : 'Sentry.captureException';

    dynamic exceptionObject;

    switch(typeToThrow) {
      case _TypeToThrow.EXCEPTION:
        exceptionObject = Exception('$title - ${typeToThrow.name()} Instance - operatingSystem: ${Platform.operatingSystem}');
        break;
      case _TypeToThrow.ERROR:
        exceptionObject = _SampleError('$title - ${typeToThrow.name()} Instance - operatingSystem: ${Platform.operatingSystem}');
        break;
      case _TypeToThrow.STRING:
        exceptionObject = '$title - ${typeToThrow.name()} Instance - operatingSystem: ${Platform.operatingSystem}';
        break;
    }

    if (fatal) {
      setState(() {
        _successResultsUnhandled[typeToThrow] = true;
      });
      throw exceptionObject;
    } else {
      try {
        throw exceptionObject;
      } catch (exception, stackTrace) {
        Sentry.captureException(exception, stackTrace: stackTrace)
            .then((value) => {
          setState(() {
            _loading = false;
            _successResultsHandled[typeToThrow] = true;
          })
        })
            .catchError((error) => {
          setState(() {
            _loading = false;
            _failureResultsHandled[typeToThrow] = Error.safeToString(error);
          })
        });
      }
    }
  }

  Future<void> _callCrashNative(_NativePlatform nativePlatform, bool primaryLanguage) async {
    switch(nativePlatform) {
      case _NativePlatform.iOS:
        if (primaryLanguage) {
          await platform.invokeMethod('crashSwift');
        } else {
          await platform.invokeMethod('crashObjectiveC');
        }
        break;
      case _NativePlatform.Android:
        if (primaryLanguage) {
          await platform.invokeMethod('crashKotlin');
        } else {
          await platform.invokeMethod('crashJava');
        }
        break;
    }
  }
}

enum _TypeToThrow {
  EXCEPTION, ERROR, STRING
}
enum _NativePlatform {
  iOS, Android
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
    return null;
  }
}

class _SampleError extends Error {
  _SampleError(this.message);

  final Object message;

  @override
  String toString() {
    return message != null
        ? 'Sample error: ${Error.safeToString(message)}'
        : 'Unknown error';
  }
}

