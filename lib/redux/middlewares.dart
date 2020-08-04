import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';
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
        final orgList = List<Map<String, dynamic>>.from(responseJson);
        final orgs = orgList.map((Map<String, dynamic> r) => Organization.fromJson(r)).toList();
        store.dispatch(FetchOrganizationsSuccessAction(orgs));
        store.dispatch(SelectOrganizationAction(orgs.first));
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
        final projList = List<Map<String, dynamic>>.from(responseJson);
        final projs = projList.map((Map<String, dynamic> r) => Project.fromJson(r)).toList();
        store.dispatch(FetchProjectsSuccessAction(projs));
        store.dispatch(SelectProjectAction(projs.first));
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
      preferences.setString('project', jsonEncode(action.payload.toJson()));
    }
    next(action);
  }
}
