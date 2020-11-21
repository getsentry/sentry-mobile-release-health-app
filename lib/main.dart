import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/middlewares.dart';
import 'package:sentry_mobile/redux/reducers.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/login/login_screen.dart';
import 'package:sentry_mobile/screens/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  final store = await createStore();

  store.dispatch(RehydrateAction());

  await SentryFlutter.init(
      (options) {
        options.dsn = 'YOUR DSN';
      },
      () {
        runApp(StoreProvider(
          store: store,
          child: SentryMobile(),
        ));
      }
  );
}

class SentryMobile extends StatelessWidget {
  SentryMobile();

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
            primaryColorLight: Color(0xffE7E1EC),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            backgroundColor: Colors.white,
            dividerColor: Color(0xffE7E1EC),

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
        home: StoreConnector<AppState, AppState>(
          builder: (_, state) {
            if (state.globalState.session == null) {
              return LoginScreen();
            } else {
              return MainScreen();
            }
          },
          converter: (store) => store.state,
        )
    );
  }
}
