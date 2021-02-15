import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../../api/api_errors.dart';
import '../../api/sentry_api.dart';

class LoginWebView extends StatefulWidget {
  LoginWebView();

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  _LoginWebViewState();

  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  final _cookieManager = WebviewCookieManager();
  var _popped = false;
  
  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  @override
  void dispose() {
    if (_onUrlChanged != null) {
      _onUrlChanged.cancel();
    }
    _flutterWebviewPlugin.dispose();
    _flutterWebviewPlugin.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _asyncUserAgent(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: WebviewScaffold(
            url: 'https://sentry.io/auth/login/',
            userAgent: snapshot.data,
            clearCookies: true,
            withZoom: false,
            hidden: true,
            appBar: AppBar(
              title: Text('Login'),
            ),
          ),
        );
      });
  }

  Future<bool> _onWillPop() async {
    // Needed for animated dismiss
    await _flutterWebviewPlugin.hide();
    return Future.value(true);
  }

  Future<String> _asyncUserAgent() async {
    try { // Platform messages may fail
      return await FlutterUserAgent.getPropertyAsync('userAgent') as String;
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> _asyncInit() async {
    await _cookieManager.clearCookies();

    _flutterWebviewPlugin.onStateChanged.listen((event) async {
      if (event.url.contains('https://sentry.io')) {
        if (event.type == WebViewState.finishLoad && !event.url.contains('/issues/')) {
          await _flutterWebviewPlugin.show();
        } else {
          await _flutterWebviewPlugin.hide();
        }
      }
    });

    // Add a listener to on url changed
    _onUrlChanged =
        _flutterWebviewPlugin.onUrlChanged.listen((String url) async {
          if (!url.contains('https://sentry.io') || !mounted) {
            // We return here, it crashes if we fetch cookies from pages like google
            return;
          }

          final cookies = await _cookieManager.getCookies(url);
          final session = cookies.firstWhere((c) => c.name == 'session', orElse: () => null);

          if (session != null) {
            // Test out an API call
            final client = SentryApi(session);
            try {
              // Session is returned even before authenticated so this is called many times
              await client.organizations();
              _popIfPossible(Result<Cookie>.value(session));
            } catch (error) {
              if (error is ApiError) {
                return; // Stay in callback loop
              } else {
                _popIfPossible(Result<Cookie>.error(error));
              }
            } finally {
              client.close();
            }
          }
        });
  }

  Future<void> _popIfPossible(Result<Cookie> result) async {
    if (mounted && !_popped) {
      _popped = true; // Don't dismiss multiple times.
      await _flutterWebviewPlugin.hide();
      Navigator.pop(context, result);
    }
  }
}