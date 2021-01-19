import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/session_group.dart';
import 'package:sentry_mobile/types/session_group_by.dart';
import 'package:sentry_mobile/types/session_group_series.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../api/sentry_api.dart';
import '../types/group.dart';
import '../types/project.dart';
import '../types/project_with_latest_release.dart';
import '../utils/throttled_action_collection.dart';
import 'actions.dart';
import 'state/app_state.dart';

class SentryApiMiddleware extends MiddlewareClass<AppState> {
  @override
  dynamic call(Store<AppState> store, action, next) {
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
            final projectsToFetch = (action.projectsByOrganizationSlug[organizationSlug] ?? [])
              .where((element) => element.latestRelease != null); // Only fetch when there is a release

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
    } else if (action is FetchLatestReleaseAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.session);
        try {
          final latestRelease = await api.release(
              organizationSlug: action.organizationSlug,
              projectId: action.projectId,
              releaseId: action.releaseId
          );
          store.dispatch(FetchLatestReleaseSuccessAction(action.projectSlug, latestRelease));
        } catch (e) {
          store.dispatch(FetchLatestReleaseFailureAction(e));
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
    } else if (action is FetchAuthenticatedUserAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.session);
        try {
          final me = await api.authenticatedUser();
          store.dispatch(
              FetchAuthenticatedUserSuccessAction(me)
          );
        } catch (e) {
          store.dispatch(FetchAuthenticatedUserFailureAction(e));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is FetchSessionsAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.session);
        try {
          final sessions = await api.sessions(
            organizationSlug: action.organizationSlug,
            projectId: action.projectId,
            field: SessionGroup.sumSessionKey,
            groupBy: SessionGroupBy.sessionStatusKey
          );

          // TODO(denis): Throttling

          store.dispatch(
              FetchSessionsSuccessAction(action.projectId, sessions)
          );
        } catch (e) {
          store.dispatch(FetchSessionsFailureAction(e));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else {
      next(action);
    }
  }
}

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  LocalStorageMiddleware(this.preferences, this.secureStorage);

  final SharedPreferences preferences;
  final FlutterSecureStorage secureStorage;

  @override
  dynamic call(Store<AppState> store, dynamic action, NextDispatcher next) async {
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
      
      await WebviewCookieManager().clearCookies();
    }
    next(action);
  }
}

// Some actions should not be run multiple times.
class ActionThrottlingMiddleware extends MiddlewareClass<AppState> {

  final _actions = ThrottledActionCollection();
  
  @override
  dynamic call(Store<AppState> store, action, next) {
    if (action is LoginAction ||
        action is LogoutAction ||
        action is FetchOrganizationsAndProjectsAction ||
        action is FetchLatestReleaseFailureAction ||
        action is FetchIssuesFailureAction) {
      // Not super elegant to clear everything on one release/issue failure,
      // but it should be enough for now.
      _actions.clear();
      next(action);
    } else if (action is ThrottledAction) {
      if (!_actions.contains(action)) {
        _actions.insert(action);
        next(action);
      }
    } else {
      next(action);
    }
  }
}
