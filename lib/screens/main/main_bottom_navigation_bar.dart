import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../utils/sentry_icons.dart';

class MainBottomNavigationBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x44B9C1D9)))
            ),
            child: BottomNavigationBar(
                elevation: 0,
                currentIndex: state.globalState.selectedTab,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.white,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(SentryIcons.home,
                      color: Color(0xffB9C1D9),
                      size: 24.0,
                    ),
                    activeIcon: Icon(SentryIcons.home,
                      color: Color(0xff81B4FE),
                      size: 24.0,
                    ),
                    title: Text('Health'),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(SentryIcons.issues,
                        color: Color(0xffB9C1D9),
                        size: 24.0,
                      ),
                      activeIcon: Icon(SentryIcons.issues,
                        color: Color(0xff81B4FE),
                        size: 24.0,
                      ),
                      title: Text('Issues')
                  )
                ],
                onTap: (int index) {
                  StoreProvider.of<AppState>(context).dispatch(SwitchTabAction(index));
                }
            ),
          );
        }
    );
  }
}