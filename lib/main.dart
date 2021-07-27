import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'redux/actions.dart';
import 'redux/middleware/secure_storage_middleware.dart';
import 'redux/middleware/sentry_api_middleware.dart';
import 'redux/middleware/sentry_sdk_middleware.dart';
import 'redux/middleware/shared_preferences_middleware.dart';
import 'redux/reducers.dart';
import 'redux/state/app_state.dart';
import 'screens/main/main_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'utils/sentry_colors.dart';

Future<Store<AppState>> createStore() async {
  final prefs = await SharedPreferences.getInstance();
  final secStorage = FlutterSecureStorage();

  return Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      SentryApiMiddleware(),
      SentrySdkMiddleware(),
      SecureStorageMiddleware(secStorage),
      SharedPreferencesMiddleware(prefs),

//      ValidationMiddleware(),
//      LoggingMiddleware.printer(),
//      LocalStorageMiddleware(prefs),
//      NavigationMiddleware()
      thunkMiddleware,
    ],
  );
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    final store = await createStore();
    store.dispatch(RehydrateAction());

    runApp(StoreProvider(
      store: store,
      child: SentryMobile(),
    ));
  }, (Object error, StackTrace stackTrace) async {
    final mechanism = Mechanism(type: 'runZonedGuarded', handled: true);
    final throwableMechanism = ThrowableMechanism(mechanism, error);

    final event = SentryEvent(
      throwable: throwableMechanism,
      level: SentryLevel.fatal,
    );

    await Sentry.captureEvent(event, stackTrace: stackTrace);
  });
}

class SentryMobile extends StatelessWidget {
  SentryMobile();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
          primarySwatch: SentryColors.primarySwatch,
          dividerColor: SentryColors.lavenderGray,

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.rubikTextTheme(
            TextTheme(
                headline1: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: SentryColors.revolver,
                ),
                headline2: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: SentryColors.revolver,
                ),
                headline3: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: SentryColors.revolver,
                ),
                headline4: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: SentryColors.revolver,
                ),
                headline5: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 26,
                  color: Colors.white,
                ),
                subtitle1: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: SentryColors.mamba,
                ),
                caption: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: SentryColors.mamba,
                )),
          )),
      home: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) {
          if (state.globalState.hydrated) {
            if (state.globalState.authToken == null) {
              return OnboardingScreen();
            } else {
              return MainScreen();
            }
          } else {
            return SplashScreen();
          }
        },
      ),
      navigatorObservers: [SentryNavigatorObserver()],
    );
  }
}
