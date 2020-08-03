import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sentry_mobile/login_viewmodel.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget content(LoginViewModel viewModel) {
    print('UPDATE Login ${viewModel.session}');

    if (viewModel.session != null) {
      return Container(
        child: Column(
          children: [
            Text(
                'You are already logged in - Expires: ${viewModel.session.expires}'),
            Center(
              child: RaisedButton(
                child: Text('Logout'),
                onPressed: () async {
                  final cookieManager = WebviewCookieManager();
                  await cookieManager.clearCookies();

                  viewModel.logout();
                },
              ),
            ),
          ],
        ),
      );
    }



    return Container(
      child: Column(
        children: [
          Center(
            child: RaisedButton(
              child: Text('Login'),
              onPressed: () async {
                showCupertinoModalBottomSheet<WebView>(
                    expand: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context, scrollController) =>
                        WebView(viewModel: viewModel));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModel>(
      builder: (_, viewModel) => content(viewModel),
      converter: (store) => LoginViewModel.fromStore(store),
    );
  }
}

class WebView extends StatefulWidget {
  WebView({this.viewModel});

  final LoginViewModel viewModel;

  @override
  _WebViewState createState() => _WebViewState(viewModel: viewModel);
}

class _WebViewState extends State<WebView> {
  _WebViewState({this.viewModel});

  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final cookieManager = WebviewCookieManager();

  StreamSubscription<String> _onUrlChanged;
  final LoginViewModel viewModel;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
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
          print('urlChanged: $url');

          final cookies = await cookieManager.getCookies(url);

          final session =
          cookies.firstWhere((c) => c.name == 'session', orElse: () => null);
          if (session != null) {
            // Test out an API call
            final client = Client();
            try {
              // Session is returned even before authenticated so this is called many times
              final cookie = session.toString();
              final response = await client.get(
                  'https://sentry.io/api/0/organizations/?member=1',
                  headers: {'Cookie': cookie});

              final orgs = response.body;
              // Until acutally logged in we hit the API a few times and get 401
              if (response.statusCode != 200) {
                print(response.statusCode);
                return;
              }

              flutterWebviewPlugin.close();
              viewModel.login(session);
              flutterWebviewPlugin.dispose();
              Navigator.pop(context);

              // Eventually works (on Android, iOS crashed on `get`):
              print(orgs);
            } catch (e) {
              print(e);
            } finally {
              client.close();
            }
          }
          print('URL changed: $url $session');
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncInit();
    });

    flutterWebviewPlugin.close();
  }

  @override
  Widget build(BuildContext context) {
    const loginUrl = 'https://sentry.io/auth/login/';
    // Google won't let you login with the default user-agent so setting something known
    final userAgent = Platform.isAndroid
        ? 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36'
        : 'Mozilla/5.0 (iPhone; CPU OS 13_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/23.0 Mobile/15E148 Safari/605.1.15';

    return WebviewScaffold(url: loginUrl, userAgent: userAgent, clearCookies: true);
  }
}
