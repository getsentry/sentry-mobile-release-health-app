import 'package:redux/redux.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_mobile/api/api_errors.dart';

import '../../api/sentry_api.dart';
import '../../types/group.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/project_with_latest_release.dart';
import '../../types/session_group.dart';
import '../../types/session_group_by.dart';
import '../actions.dart';
import '../state/app_state.dart';

class SentryApiMiddleware extends MiddlewareClass<AppState> {
  @override
  dynamic call(Store<AppState> store, action, next) {
    if (action is FetchOrgsAndProjectsAction) {
      final thunkAction = (Store<AppState> store) async {
        final orgsAndProjectsSpan =
            Sentry.getSpan()?.startChild('FetchOrgsAndProjectsAction') ??
                Sentry.startTransaction('FetchOrgsAndProjectsAction', 'action');

        final api = SentryApi(store.state.globalState.authToken);
        try {
          store.dispatch(FetchOrgsAndProjectsProgressAction(
              'Fetching organizations...', null));
          final organizations = await api.organizations();
          final individualOrganizations = <Organization>[];
          final Set<String> projectIdsWithSessions = {};
          final Map<String, List<Project>> projectsByOrganizationId = {};

          final fullProgress = organizations.length * 2;
          var currentProgress = 0;

          for (final organization in organizations) {
            final organizationSpan = orgsAndProjectsSpan.startChild(
              'organization',
              description: 'Fetch organization',
            );
            try {
              final individualOrganization =
                  await api.organization(organization.slug);
              individualOrganizations.add(individualOrganization);
            } catch (e) {
              organizationSpan.throwable = e;
              organizationSpan.status = SpanStatus.internalError();
              rethrow;
            } finally {
              await organizationSpan.finish(status: SpanStatus.ok());
            }

            store.dispatch(FetchOrgsAndProjectsProgressAction(
                '${organization.name}: Fetching projects...',
                ++currentProgress / fullProgress));
            final projects = await api.projects(organization.slug);
            if (projects.isNotEmpty) {
              projectsByOrganizationId[organization.slug] = projects;
            }

            store.dispatch(FetchOrgsAndProjectsProgressAction(
                '${organization.name}: Checking for sessions...',
                ++currentProgress / fullProgress));

            final projectIdsSpan = orgsAndProjectsSpan.startChild(
              'projectIds',
              description: 'Fetch projectIds',
            );
            try {
              final projectsWithSessionsForOrganization =
                  await api.projectIdsWithSessions(organization.slug);
              projectIdsWithSessions
                  .addAll(projectsWithSessionsForOrganization);
            } catch (e) {
              projectIdsSpan.throwable = e;
              if (e is ApiError && e.statusCode == 400) {
                projectIdsSpan.status = SpanStatus.fromHttpStatusCode(400);
                Sentry.addBreadcrumb(Breadcrumb(
                    message: 'Org has no projects -> $e',
                    level: SentryLevel.error));
              } else {
                projectIdsSpan.status = SpanStatus.internalError();
                rethrow;
              }
            } finally {
              await projectIdsSpan.finish(status: SpanStatus.ok());
            }
          }
          store.dispatch(FetchOrgsAndProjectsSuccessAction(
              individualOrganizations,
              projectsByOrganizationId,
              projectIdsWithSessions));
        } catch (e, s) {
          orgsAndProjectsSpan.throwable = e;
          orgsAndProjectsSpan.status = SpanStatus.internalError();
          store.dispatch(FetchOrgsAndProjectsFailureAction(e, s));
        } finally {
          await orgsAndProjectsSpan.finish(status: SpanStatus.ok());
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is FetchLatestReleasesAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.authToken);
        try {
          final List<ProjectWithLatestRelease> projectsWithLatestRelease = [];

          for (final organizationSlug
              in action.projectsByOrganizationSlug.keys) {
            final projectsToFetch =
                (action.projectsByOrganizationSlug[organizationSlug] ?? [])
                    .where((element) =>
                        element.latestRelease !=
                        null); // Only fetch when there is a release

            for (final projectToFetch in projectsToFetch) {
              final project =
                  await api.project(organizationSlug, projectToFetch.slug);
              final latestRelease = await api.release(
                  organizationSlug: organizationSlug,
                  projectId: project.id,
                  releaseId: project.latestRelease!.version);
              projectsWithLatestRelease
                  .add(ProjectWithLatestRelease(project, latestRelease));
            }
          }
          store.dispatch(
              FetchLatestReleasesSuccessAction(projectsWithLatestRelease));
        } catch (e, s) {
          store.dispatch(FetchLatestReleasesFailureAction(e, s));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is FetchLatestReleaseAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.authToken);
        try {
          final latestRelease = await api.release(
              organizationSlug: action.organizationSlug,
              projectId: action.projectId,
              releaseId: action.releaseId);
          store.dispatch(FetchLatestReleaseSuccessAction(
              action.projectSlug, latestRelease));
        } catch (e, s) {
          store.dispatch(FetchLatestReleaseFailureAction(e, s));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is FetchIssuesAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.authToken);
        try {
          final List<Group> issues = await api.issues(
            organizationSlug: action.organizationSlug,
            projectSlug: action.projectSlug,
          );
          store.dispatch(FetchIssuesSuccessAction(action.projectSlug, issues));
        } catch (e, s) {
          store.dispatch(FetchIssuesFailureAction(e, s));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is FetchAuthenticatedUserAction) {
      final thunkAction = (Store<AppState> store) async {
        final api =
            SentryApi(store.state.globalState.authToken ?? action.authToken);
        try {
          final me = await api.authenticatedUser();
          store.dispatch(FetchAuthenticatedUserSuccessAction(me));
        } catch (e, s) {
          store.dispatch(FetchAuthenticatedUserFailureAction(e, s));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is FetchSessionsAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.authToken);
        try {
          final sessions = await api.sessions(
              organizationSlug: action.organizationSlug,
              projectId: action.projectId,
              fields: [
                SessionGroup.sumSessionKey,
                SessionGroup.countUniqueUsersKey
              ],
              groupBy: SessionGroupBy.sessionStatusKey,
              statsPeriodStart: '25h',
              statsPeriodEnd: '1h');

          final sessionsBefore = await api.sessions(
              organizationSlug: action.organizationSlug,
              projectId: action.projectId,
              fields: [
                SessionGroup.sumSessionKey,
                SessionGroup.countUniqueUsersKey
              ],
              groupBy: SessionGroupBy.sessionStatusKey,
              statsPeriodStart: '49h',
              statsPeriodEnd: '25h');

          store.dispatch(FetchSessionsSuccessAction(
              action.projectId, sessions, sessionsBefore));
        } catch (e, s) {
          store.dispatch(FetchSessionsFailureAction(e, s));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is BookmarkProjectAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.authToken);
        try {
          final project = await api.bookmarkProject(
              action.organizationSlug, action.projectSlug, action.bookmarked);
          store.dispatch(
              BookmarkProjectSuccessAction(action.organizationSlug, project));
        } catch (e, s) {
          store.dispatch(BookmarkProjectFailureAction(
              action.projectSlug, !action.bookmarked, e, s));
        }
        api.close();
      };
      next(action);
      store.dispatch(thunkAction);
    } else if (action is FetchApdexAction) {
      final thunkAction = (Store<AppState> store) async {
        final api = SentryApi(store.state.globalState.authToken);
        try {
          final now = DateTime.now();
          final twentyFourHoursAgo = now.add(Duration(hours: -24));
          final fortyEightHoursAgo = now.add(Duration(hours: -48));

          final apdex = await api.apdex(
              apdexThreshold: action.apdexThreshold,
              organizationSlug: action.organizationSlug,
              projectId: action.projectId,
              start: twentyFourHoursAgo,
              end: now);

          final apdexBefore = await api.apdex(
              apdexThreshold: action.apdexThreshold,
              organizationSlug: action.organizationSlug,
              projectId: action.projectId,
              start: fortyEightHoursAgo,
              end: twentyFourHoursAgo);

          store.dispatch(
              FetchApdexSuccessAction(action.projectId, apdex, apdexBefore));
        } catch (e, s) {
          store.dispatch(FetchApdexFailureAction(e, s));
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
