import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/organization_slug_with_project_id.dart';
import 'package:sentry_mobile/types/project_with_latest_release.dart';
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

  if (action is FetchLatestReleasesAction) {
    for (final slugWithId in action.organizationSlugsWithProjectId) {
      try {
        final project = await api.project(
            slugWithId.organizationSlug, slugWithId.projectSlug
        );
        final release = await api.release(
            organizationSlug: slugWithId.organizationSlug,
            projectId: project.id,
            releaseId: project.latestRelease.version
        );
        store.dispatch(FetchReleasesSuccessAction(project, release));
      } catch (e) {
        store.dispatch(FetchReleasesFailureAction(e));
      }
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
        final deserialized = selectedProjectIds
            .map((e) => OrganizationSlugWithProjectId(e.split(';')[0], e.split(';')[1], e.split(';')[2]))
            .toList();
        store.dispatch(SelectProjectsAction(deserialized));
      }
    }
    if (action is SelectProjectAction) {
      final serialized = store.state.globalState.selectedOrganizationSlugsWithProjectId
          .map((e) => '${e.organizationSlug};${e.projectId};${e.projectSlug}')
          .toList();
      await preferences.setStringList('selectedProjectIds', serialized);
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
