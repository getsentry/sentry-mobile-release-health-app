import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../redux/state/app_state.dart';
import '../../utils/sentry_colors.dart';
import 'connect_view_model.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConnectViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => ConnectViewModel.fromStore(store),
    );
  }

  Widget _content(ConnectViewModel viewModel) {
    return Container(
        margin: EdgeInsets.all(32.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Lets get started!',
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
                      onPressed: () => _openAccountSettings()
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonTheme(
                      minWidth: 144,
                      child: RaisedButton.icon(
                        label: Text('Scan Code'),
                        icon: Icon(
                            Icons.qr_code,
                            color: Colors.white
                        ),
                        textColor: Colors.white,
                        color: SentryColors.rum,
                        onPressed: () {
                          // TODO @denis
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('OR'),
                    SizedBox(height: 12),
                    ButtonTheme(
                      minWidth: 144,
                      child: RaisedButton.icon(
                        label: Text('Enter Code'),
                        icon: Icon(
                            Icons.content_paste_rounded,
                            color: Colors.white
                        ),
                        textColor: Colors.white,
                        color: SentryColors.rum,
                        onPressed: () {
                          // TODO @denis
                        },
                      ),
                    ),
                  ],
                )

              ],
            )
        )
    );
  }

  Future<void> _openAccountSettings() async {
    const url = 'https://sentry.io/settings/account/details/';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _handleLoginFailure(Object error) {
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
              'Oops, there is a problem. Please try again later.',
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