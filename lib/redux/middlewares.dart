import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/sentry_api.dart';
import '../types/group.dart';
import '../types/project.dart';
import '../types/project_with_latest_release.dart';
import 'actions.dart';
import 'state/app_state.dart';

void apiMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) async {

  if (action is FetchOrganizationsAndProjectsAction) {
    final thunkAction = (Store<AppState> store) async {
      final api = SentryApi(store.state.globalState.session);
      try {
        final organizations = await api.organizations();
        final Map<String, List<Project>> projectsByOrganizationId = {};
        for (final organization in organizations) {
          final projects = await api.projects(organization.slug);
          if (projects.isNotEmpty) {
            projectsByOrganizationId[organization.slug] = projects;
          }
        }
        store.dispatch(FetchOrganizationsAndProjectsSuccessAction(organizations, projectsByOrganizationId));
      } catch (e) {
        store.dispatch(FetchOrganizationsAndProjectsFailureAction(e));
      }
      api.close();
    };
    next(action);
    store.dispatch(thunkAction);
  } else if (action is FetchLatestReleasesAction) {
    final thunkAction = (Store<AppState> store) async {
      final api = SentryApi(store.state.globalState.session);
      try {
        final List<ProjectWithLatestRelease> projectsWithLatestRelease = [];

        for (final organizationSlug in action.projectsByOrganizationSlug.keys) {
          final projectsToFetch = action.projectsByOrganizationSlug[organizationSlug] ?? [];
          for (final projectToFetch in projectsToFetch) {
            final project = await api.project(
              organizationSlug, projectToFetch.slug
            );
            final latestRelease = await api.release(
              organizationSlug: organizationSlug,
              projectId: project.id,
              releaseId: project.latestRelease.version
            );
            projectsWithLatestRelease.add(ProjectWithLatestRelease(project, latestRelease));
          }
        }
        store.dispatch(FetchLatestReleasesSuccessAction(projectsWithLatestRelease));
      } catch (e) {
        store.dispatch(FetchLatestReleasesFailureAction(e));
      }
      api.close();
    };
    next(action);
    store.dispatch(thunkAction);
  } else if (action is FetchIssuesAction) {
    final thunkAction = (Store<AppState> store) async {
      final api = SentryApi(store.state.globalState.session);
      try {
        final List<Group> issues = await api.issues(
          organizationSlug: action.organizationSlug,
          projectSlug: action.projectSlug,
          fetchUnhandled: action.unhandled
        );
        store.dispatch(
          FetchIssuesSuccessAction(action.projectSlug, action.unhandled, issues)
        );
      } catch (e) {
        store.dispatch(FetchIssuesFailureAction(e));
      }
      api.close();
    };
    next(action);
    store.dispatch(thunkAction);
  } else {
    next(action);
  }
}

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  LocalStorageMiddleware(this.preferences, this.secureStorage);

  final SharedPreferences preferences;
  final FlutterSecureStorage secureStorage;

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RehydrateAction) {
      final String session = await secureStorage.read(key: 'session');
      Cookie cookie;
      try {
        cookie = session != null ? Cookie.fromSetCookieValue(session) : null;
      } catch (e) {
        await secureStorage.delete(key: 'session');
      }
      store.dispatch(RehydrateSuccessAction(cookie));
    }
    if (action is LoginAction) {
      await secureStorage.write(key: 'session', value: action.cookie.toString());
    }
    if (action is LogoutAction) {
      await secureStorage.delete(key: 'session');
      await preferences.clear();
    }
    next(action);
  }
}
