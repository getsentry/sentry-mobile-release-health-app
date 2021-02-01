import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../redux/state/app_state.dart';
import '../health/release_health.dart';
import 'main_app_bar.dart';
// import 'main_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // final _children = [
  //   ReleaseHealth(),
  //   IssuesScreenBuilder()
  // ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      builder: (_, state) => _content(state),
      converter: (store) => store
    );
  }

  Widget _content(Store<AppState> store) {

    // todo(denis): Change back once issues are implemented.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(),
      // bottomNavigationBar: MainBottomNavigationBar(),
      // body: Center(
      //   child: _children[store.state.globalState.selectedTab],
      // ),
      body: ReleaseHealth(),
    );
  }
}




