import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return client.get('$baseUrl/me/', headers: {'Cookie': session.toString()});
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

        store.dispatch(FetchOrganizationsSuccessAction(List<Map<String, dynamic>>.from(responseJson)));
        store.dispatch(
            FetchProjectsAction(store.state.globalState.selectedOrganization));
      } else {
        store.dispatch(FetchOrganizationsFailureAction());
      }
    } catch (e) {
      store.dispatch(FetchOrganizationsFailureAction());
    }
  }

  if (action is FetchProjectsAction) {
    try {
      final response = await api.projects(action.payload);
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body) as List;
        store.dispatch(FetchProjectsSuccessAction(List<Map<String, dynamic>>.from(responseJson)));
      } else {
        store.dispatch(FetchProjectsFailureAction());
      }
    } catch (e) {
      store.dispatch(FetchProjectsFailureAction());
    }
  }

  api.close();
  next(action);
}

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  LocalStorageMiddleware(this.preferences);

  final SharedPreferences preferences;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action is SelectProjectAction) {
      preferences.setString('project', action.payload.toString());
    }
    next(action);
  }
}
