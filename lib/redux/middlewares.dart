import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/sentry_api.dart';
import '../types/organization.dart';
import '../types/project.dart';
import 'actions.dart';
import 'state/app_state.dart';

void apiMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) async {
  final api = SentryApi(store.state.globalState.session);

  if (action is FetchOrganizationsAction) {
    try {
      final organizations = await api.organizations();
        store.dispatch(FetchOrganizationsSuccessAction(organizations));
        for (final organization in organizations) {
          store.dispatch(FetchProjectsAction(organization));
        }
    } catch (e) {
      store.dispatch(FetchOrganizationsFailureAction(e));
    }
  }

  if (action is FetchProjectsAction) {
    try {
      final projects = await api.projects(action.organization.slug);
      store.dispatch(FetchProjectsSuccessAction(action.organization.id, projects));
    } catch (e) {
      store.dispatch(FetchProjectsFailureAction(e));
    }
  }

  if (action is FetchReleasesAction) {
    try {
      final releases = await api.releases(organizationSlug: action.organizationSlug, projectId: action.projectId);
      store.dispatch(FetchReleasesSuccessAction(releases));
    } catch (e) {
      store.dispatch(FetchReleasesFailureAction(e));
    }
  }

  if (action is FetchReleaseAction) {
    try {
      final release = await api.release(projectId: action.projectId, releaseId: action.releaseId);
      store.dispatch(FetchReleaseSuccessAction(release));
    } catch (e) {
      store.dispatch(FetchReleaseFailureAction(e));
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

      final selectedProjectIds = preferences.getStringList('selectedProjectIds');
      if (selectedProjectIds != null) {
        store.dispatch(SelectProjectsAction(selectedProjectIds));
      }
    }
    if (action is SelectProjectAction) {
      await preferences.setStringList('selectedProjectIds', store.state.globalState.selectedProjectIds.toList());
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
