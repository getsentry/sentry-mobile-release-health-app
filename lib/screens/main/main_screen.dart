import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

import 'package:sentry_mobile/issues.dart';
import 'package:sentry_mobile/screens/release_health/release_health.dart';
import 'package:sentry_mobile/settings.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      builder: (_, state) => _content(state),
      converter: (store) => store
    );
  }

  Widget _content(Store<AppState> store) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Header(),
        bottomNavigationBar: Material(
            color: Color(0xffffffff),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0x44B9C1D9)))),
              height: 84.0,
              child: Column(
                children: [
                  TabBar(
                    onTap: (int index) {
                      store.dispatch(SwitchTabAction(index));
                    },
                    indicator: CircleTabIndicator(
                        color: Colors.transparent, radius: 3),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.home,
                            color:
                            // hacky, but don't want to fight with built in tabs
                            store.state.globalState.selectedTab == 0
                                ? Color(0xff81B4FE)
                                : Color(0xffB9C1D9)),
                        iconMargin: EdgeInsets.only(bottom: 0),
                        text: '',
                      ),
                      Tab(
                        icon: Icon(Icons.inbox,
                            color:
                            store.state.globalState.selectedTab == 1
                                ? Color(0xff81B4FE)
                                : Color(0xffB9C1D9)),
                        iconMargin: EdgeInsets.only(bottom: 0),
                        text: '',
                      ),
                      Tab(
                        icon: Icon(Icons.account_circle,
                            color:
                            store.state.globalState.selectedTab == 2
                                ? Color(0xff81B4FE)
                                : Color(0xffB9C1D9)),
                        iconMargin: EdgeInsets.only(bottom: 0),
                        text: '',
                      ),
                    ],
                  )
                ],
              ),
            )),
        body: TabBarView(
          children: [
            ReleaseHealth(),
            IssuesScreenBuilder(),
            Settings(),
          ],
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget with PreferredSizeWidget {
  Header({this.store});

  final Store<AppState> store;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      builder: (_, state) {
        var title = 'Health';
        switch (state.globalState.selectedTab) {
          case 1:
            title = 'Top Issues';
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
            centerTitle: false,
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
              )
            ],
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline1,
            ));
      },
      converter: (store) => store.state,
    );
  }
}

class CircleTabIndicator extends Decoration {
  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  final BoxPainter _painter;

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  final Paint _paint;
  final double radius;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5 - 20);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}