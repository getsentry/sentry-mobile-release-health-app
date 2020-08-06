import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/issues.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/middlewares.dart';
import 'package:sentry_mobile/redux/reducers.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/release_health.dart';
import 'package:sentry_mobile/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Store<AppState>> createStore() async {
  final prefs = await SharedPreferences.getInstance();
  final secStorage = FlutterSecureStorage();
  return Store(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      apiMiddleware,
      LocalStorageMiddleware(prefs, secStorage)
//      ValidationMiddleware(),
//      LoggingMiddleware.printer(),
//      LocalStorageMiddleware(prefs),
//      NavigationMiddleware()
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  final store = await createStore();

  store.dispatch(RehydrateAction());

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  MyApp({this.store});

  final Store<AppState> store;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sentry',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
            primarySwatch: Colors.purple,
            primaryColorDark: Color(0xff4e3fb4),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            backgroundColor: Colors.white,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.rubikTextTheme(
              TextTheme(
                  headline1: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                  headline2: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  headline3: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  headline4: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  headline5: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                  subtitle1: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xb3ffffff),
                  ),
                  caption: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black45,
                  )),
            )),
        home: CustomSplash(
          imagePath: 'assets/splash.png',
          backGroundColor: Color(0x00564f64),
          animationEffect: 'fade-in',
          logoSize: 300,
          // customFunction: (_) {
          //   return 1;
          // },
          duration: 1500,
          type: CustomSplashType.StaticDuration,
          home: StoreProvider<AppState>(
            store: store,
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (context, state) {
                  return DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: Header(),
                      bottomNavigationBar: Material(
                          color: Color(0xffffffff),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Color(0xffB9C1D9)))),
                            height: 84.0,
                            child: Column(
                              children: [
                                TabBar(
                                  onTap: (int index) {
                                    store.dispatch(SwitchTabAction(index));
                                  },
                                  indicator: CircleTabIndicator(
                                      color: Color(0xffB9C1D9), radius: 3),
                                  tabs: [
                                    Tab(
                                      icon: Icon(
                                        Icons.healing,
                                        color: Color(0xffB9C1D9),
                                      ),
                                      iconMargin: EdgeInsets.only(bottom: 0),
                                      text: '',
                                    ),
                                    Tab(
                                      icon: Icon(Icons.list,
                                          color: Color(0xffB9C1D9)),
                                      iconMargin: EdgeInsets.only(bottom: 0),
                                      text: '',
                                    ),
                                    Tab(
                                      icon: Icon(Icons.account_circle,
                                          color: Color(0xffB9C1D9)),
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
                }),
          ),
        ));
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
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
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
