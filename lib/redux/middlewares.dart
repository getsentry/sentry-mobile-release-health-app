import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

void apiMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) async {
  if (action is FetchOrganizationsAction) {
    final cookie = store.state.globalState.session.toString();
    final client = Client();
    try {
      final response = await client.get(
          'https://sentry.io/api/0/organizations/?member=1',
          headers: {'Cookie': cookie});

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body) as List;
        store.dispatch(FetchOrganizationsSuccessAction(responseJson));
      } else {
        store.dispatch(FetchOrganizationsFailureAction());
      }
    } catch (e) {
      store.dispatch(FetchOrganizationsFailureAction());
    } finally {
      client.close();
    }
  }


  next(action);
}