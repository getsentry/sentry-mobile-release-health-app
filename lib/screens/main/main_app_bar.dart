import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

import '../../redux/state/app_state.dart';
import '../../utils/sentry_icons.dart';
import '../settings/settings.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) {
        var title = 'Health';
        switch (state.globalState.selectedTab) {
          case 1:
            title = 'Issues';
            break;
          case 2:
            title = 'Settings';
            break;
          default:
            title = 'Health';
            break;
        }

        return AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            brightness: Brightness.light,
            centerTitle: false,
            actions: [
              IconButton(
                icon: Icon(SentryIcons.settings),
                color: SentryColors.snuff,
                onPressed: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Settings()
                      ),
                    ),
              )
            ],
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline1,
            ));
      },
    );
  }
}