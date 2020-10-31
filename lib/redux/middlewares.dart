import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sentry_mobile/api/sentry_api.dart';

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
  LocalStorageMiddleware(this.preferences, this.secureStorage);

  final SharedPreferences preferences;
  final FlutterSecureStorage secureStorage;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final String session = await secureStorage.read(key: 'session');
      if (session != null) {
        store.dispatch(LoginAction(Cookie.fromSetCookieValue(session)));
      }

      final projectJson = preferences.getString('project');
      if (projectJson != null) {
        final project = Project.fromJson(json.decode(projectJson) as Map<String, dynamic>);
        store.dispatch(SelectProjectAction(project));
      }

      final organizationJson = preferences.getString('organization');
      if (organizationJson != null) {
        final organization = Organization.fromJson(
            json.decode(organizationJson) as Map<String, dynamic>);
        store.dispatch(SelectOrganizationAction(organization));
      }
    }
    if (action is SelectProjectAction) {
      await preferences.setString('project', jsonEncode(action.payload.toJson()));
    }
    if (action is SelectOrganizationAction) {
      await preferences.setString('organization', jsonEncode(action.payload.toJson()));
    }
    if (action is LoginAction) {
      await secureStorage.write(key: 'session', value: action.payload.toString());
    }
    if (action is LogoutAction) {
      await secureStorage.delete(key: 'session');
      await preferences.clear();
    }
    next(action);
  }
}
