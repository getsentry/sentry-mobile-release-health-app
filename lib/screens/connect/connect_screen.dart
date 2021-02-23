import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../redux/state/app_state.dart';
import '../../screens/scanner/scanner_screen.dart';
import '../../utils/sentry_colors.dart';
import 'connect_view_model.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConnectViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => ConnectViewModel.fromStore(store),
    );
  }

  Widget _content(ConnectViewModel viewModel) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ok, lets go!',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Connect in your account settings\nto see your session data.',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  FlatButton(
                    textColor: SentryColors.royalBlue,
                    child: Text('Open Account Settings'),
                    onPressed: _openAccountSettings
                  )
                ],
              ),
            ),
            if (_loading)
              Expanded(
                flex: 3,
                child: Center(child: CircularProgressIndicator())
              )
            else
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    ButtonTheme(
                      minWidth: 144,
                      child: RaisedButton.icon(
                          label: Text('Scan Token'),
                          icon: Icon(
                              Icons.qr_code,
                              color: Colors.white
                          ),
                          textColor: Colors.white,
                          color: SentryColors.rum,
                          onPressed: () async {
                            final encodedToken = await _presentScannerScreen();
                            setState(() {
                              _loading = encodedToken != null;
                            });
                            try {
                              await viewModel.onTokenEncoded(encodedToken);
                            } catch (_) {
                              setState(() {
                                _loading = false;
                              });
                              _handleTokenFailure();
                            }
                          }
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('OR'),
                    SizedBox(height: 12),
                    ButtonTheme(
                      minWidth: 144,
                      child: RaisedButton.icon(
                        label: Text('Enter Token'),
                        icon: Icon(
                            Icons.content_paste_rounded,
                            color: Colors.white
                        ),
                        textColor: Colors.white,
                        color: SentryColors.rum,
                        onPressed: () async {
                          final enteredToken = await _showDialog();
                          setState(() {
                            _loading = enteredToken != null;
                          });
                          try {
                            await viewModel.onToken(enteredToken);
                          } catch (_) {
                            setState(() {
                              _loading = false;
                            });
                            _handleTokenFailure();
                          }
                        },
                      ),
                    ),
                  ],
                )
              )
          ],
        )
    );
  }

  Future<void> _openAccountSettings() async {
    const url = 'https://sentry.io/settings/account/api/mobile-app/';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<String> _presentScannerScreen() async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => ScannerScreen()
      ),
    ) as String;
  }

  Future<String> _showDialog() async {
    String enteredToken;
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text('Enter Token'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Auth Token',
                hintText: 'Enter your auth token here'
            ),
            onChanged: (value) {
              enteredToken = value;
            },
          ),
          actions: <Widget>[
            FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                }),
            FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(enteredToken);
                })
          ],
        );
      },
    );
  }

  void _handleTokenFailure() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Error',
              style: Theme.of(context).textTheme.headline1
          ),
          content: Text(
              'Something went wrong. Please try again.',
              style: Theme.of(context).textTheme.bodyText1
          ),
          actions: [
            FlatButton(
                key: Key('ok'),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok')),
          ],
        );
      }
    );
  }
}