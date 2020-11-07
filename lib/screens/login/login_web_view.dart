import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:sentry_mobile/api/sentry_api.dart';

class LoginWebView extends StatefulWidget {
  LoginWebView();

  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  _LoginWebViewState();

  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final cookieManager = WebviewCookieManager();

  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    flutterWebviewPlugin.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const loginUrl = 'https://sentry.io/auth/login/';
    // Google won't let you login with the default user-agent so setting something known
    final userAgent = Platform.isAndroid != null
        ? 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36'
        : 'Mozilla/5.0 (iPhone; CPU OS 13_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/23.0 Mobile/15E148 Safari/605.1.15';

    return WebviewScaffold(
      url: loginUrl,
      userAgent: userAgent,
      clearCookies: true,
      withZoom: false,
      hidden: true,
      appBar: AppBar(
        title: Text('SignIn'),
      ),
    );
  }

  void _asyncInit() async {
    await cookieManager.clearCookies();
    await flutterWebviewPlugin.getCookies();

    // Add a listener to on url changed
    _onUrlChanged =
        flutterWebviewPlugin.onUrlChanged.listen((String url) async {
          if (!url.contains('https://sentry.io')) {
            // We return here, it crashes if we fetch cookies from pages like google
            return;
          }

          final cookies = await cookieManager.getCookies(url);
          final session = cookies.firstWhere((c) => c.name == 'session', orElse: () => null);

          if (session != null) {
            // Test out an API call
            final client = SentryApi(session);
            try {
              // Session is returned even before authenticated so this is called many times
              final response = await client.organizations();

              // Until actually logged in we hit the API a few times and get 401
              if (response.statusCode == 200) {
                client.close();
                Navigator.pop(context, session);
              }
            } catch (e) {
              print(e);
            }
          }
        });
  }
}