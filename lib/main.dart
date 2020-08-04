import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
  return Store(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      apiMiddleware,
      LocalStorageMiddleware(prefs)
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

  final String session =
      await store.state.globalState.storage.read(key: 'session');

  if (session != null) {
    store.dispatch(LoginAction(Cookie.fromSetCookieValue(session)));
  }

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

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
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.rubikTextTheme(
              TextTheme(
                  headline1: TextStyle(
                    fontWeight: FontWeight.w700,
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
                  caption: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black45,
                  )),
            )),
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
                        color: Colors.purple[900],
                        child: Container(
                          height: 60.0,
                          child: TabBar(
                            tabs: [
                              Tab(
                                icon: Icon(Icons.healing),
                                text: 'Health',
                                iconMargin: EdgeInsets.only(bottom: 4),
                              ),
                              Tab(
                                icon: Icon(Icons.list),
                                text: 'Issues',
                                iconMargin: EdgeInsets.only(bottom: 4),
                              ),
                              Tab(
                                icon: Icon(Icons.account_circle),
                                text: 'Settings',
                                iconMargin: EdgeInsets.only(bottom: 4),
                              ),
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
      builder: (_, viewModel) => AppBar(
        backgroundColor: Colors.purple[900],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
                child: Image(image: AssetImage('assets/sentry-logo-light-512.png'), height: 32)),
            Visibility(
              visible: true,
              child: Center(child: Text(
                '${viewModel.globalState.selectedOrganization?.name} / ${viewModel.globalState.selectedProject?.name}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              )),
            ),
          ],
        ),
      ),
      converter: (store) => store.state,
    );
  }
}
