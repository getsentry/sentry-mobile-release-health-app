import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';

class SentryApi {
  SentryApi(this.session);

  final Cookie session;
  final client = Client();
  final baseUrl = 'https://sentry.io/api/0';

  Future<Response> organizations() async {
    return client.get('$baseUrl/organizations/?member=1',
        headers: {'Cookie': session.toString()});
  }

  Future<Response> me() async {
    return client.get('$baseUrl/me/',
        headers: {'Cookie': session.toString()});
  }

  Future<Response> projects(Organization organization) async {
    return client.get('$baseUrl/organizations/${organization.slug}/projects/',
        headers: {'Cookie': session.toString()});
  }

  void close() {
    client.close();
  }
}

void apiMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) async {
  final api = SentryApi(store.state.globalState.session);

  if (action is FetchOrganizationsAction) {
    try {
      final response = await api.organizations();
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body) as List;
        store.dispatch(FetchOrganizationsSuccessAction(responseJson));
      } else {
        store.dispatch(FetchOrganizationsFailureAction());
      }
    } catch (e) {
      store.dispatch(FetchOrganizationsFailureAction());
    }
  }

  api.close();
  next(action);
}
