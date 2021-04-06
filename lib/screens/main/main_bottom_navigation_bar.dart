

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../utils/sentry_colors.dart';
import '../../utils/sentry_icons.dart';

class MainBottomNavigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return BottomNavigationBar(
              elevation: 0,
              currentIndex: state.globalState.selectedTab,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: SentryColors.rum,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(SentryIcons.home,
                    color: SentryColors.graySuit,
                    size: 24.0,
                  ),
                  activeIcon: Icon(SentryIcons.home,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  label: 'Sessions',
                ),
                BottomNavigationBarItem(
                    icon: Icon(SentryIcons.issues,
                      color: SentryColors.graySuit,
                      size: 24.0,
                    ),
                    activeIcon: Icon(SentryIcons.issues,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    label: 'Issues'
                )
              ],
              onTap: (int index) {
                StoreProvider.of<AppState>(context).dispatch(SwitchTabAction(index));
              }
          );
        }
    );
  }
}