import 'dart:io';

import 'package:sentry_mobile/types/release.dart';

import '../../redux/state/session_state.dart';
import '../../screens/chart/line_chart_point.dart';
import '../../types/group.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/project_with_latest_release.dart';
import '../../types/session_status.dart';
import '../../types/sessions.dart';
import '../../types/user.dart';

class AppState {
  AppState({this.globalState});

  factory AppState.initial() {
    return AppState(
      globalState: GlobalState.initial(),
    );
  }

  final GlobalState globalState;

  AppState copyWith({GlobalState globalState}) {
    return AppState(
      globalState: globalState ?? this.globalState,
    );
  }
}

class GlobalState {
  GlobalState(
      {this.session,
      this.hydrated,
      this.version,
      this.selectedTab,
      this.organizations,
      this.organizationsSlugByProjectSlug,
      this.projectsByOrganizationSlug,
      this.projectsFetchedOnce,
      this.projectsLoading,
      this.projects,
      this.latestReleasesByProjectId,
      this.sessionsByProjectId,
      this.sessionsBeforeByProjectId,
      this.crashFreeSessionsByProjectId,
      this.crashFreeSessionsBeforeByProjectId,
      this.crashFreeUsersByProjectId,
      this.crashFreeUsersBeforeByProjectId,
      this.apdexByProjectId,
      this.apdexBeforeByProjectId,
      this.issuesByProjectSlug,
      this.selectedOrganization,
      this.selectedProject,
      this.me});

  factory GlobalState.initial() {
    return GlobalState(
      session: null,
      hydrated: false,
      version: '--',
      selectedTab: 0,
      organizations: [],
      organizationsSlugByProjectSlug: {},
      projectsByOrganizationSlug: {},
      projectsFetchedOnce: false,
      projectsLoading: false,
      projects: [],
      latestReleasesByProjectId: {},
      sessionsByProjectId: {},
      sessionsBeforeByProjectId: {},
      issuesByProjectSlug: {},
      crashFreeSessionsByProjectId: {},
      crashFreeSessionsBeforeByProjectId: {},
      crashFreeUsersByProjectId: {},
      crashFreeUsersBeforeByProjectId: {},
      apdexByProjectId: {},
      apdexBeforeByProjectId: {},
      selectedOrganization: null,
      selectedProject: null,
      me: null
    );
  }

  final Cookie session;
  final bool hydrated;
  final String version;
  final int selectedTab;

  final List<Organization> organizations;
  final Map<String, String> organizationsSlugByProjectSlug;
  final Map<String, List<Project>> projectsByOrganizationSlug;
  final bool projectsFetchedOnce;
  final bool projectsLoading;

  final List<Project> projects;
  final Map<String, Release> latestReleasesByProjectId;

  final Map<String, Sessions> sessionsByProjectId;
  final Map<String, Sessions> sessionsBeforeByProjectId; // Interval before sessionsByProjectId
  final Map<String, double> crashFreeSessionsByProjectId;
  final Map<String, double> crashFreeSessionsBeforeByProjectId; // Interval before stabilityScoreByProjectId
  final Map<String, double> crashFreeUsersByProjectId;
  final Map<String, double> crashFreeUsersBeforeByProjectId; // Interval before stabilityScoreByProjectId
  final Map<String, double> apdexByProjectId;
  final Map<String, double> apdexBeforeByProjectId; // Interval before apdexByProjectId

  final Map<String, List<Group>> issuesByProjectSlug;

  final Organization selectedOrganization;
  final Project selectedProject;

  final User me;

  GlobalState copyWith({
    Cookie session,
    bool hydrated,
    String version,
    int selectedTab,
    bool setSessionNull = false,
    List<Organization> organizations,
    final Map<String, String> organizationsSlugByProjectSlug,
    final Map<String, List<Project>> projectsByOrganizationSlug,
    bool projectsFetchedOnce,
    bool projectsLoading,
    List<Project> projects,
    Map<String, Release> latestReleasesByProjectId,
    Map<String, Sessions> sessionsByProjectId,
    Map<String, Sessions> sessionsBeforeByProjectId,
    Map<String, double> crashFreeSessionsByProjectId,
    Map<String, double> crashFreeSessionsBeforeByProjectId,
    Map<String, double> crashFreeUsersByProjectId,
    Map<String, double> crashFreeUsersBeforeByProjectId,
    Map<String, double> apdexByProjectId,
    Map<String, double> apdexBeforeByProjectId,
    Map<String, List<Group>> issuesByProjectSlug,
    Organization selectedOrganization,
    Project selectedProject,
    User me,
  }) {
    return GlobalState(
      session: setSessionNull ? null : (session ?? this.session),
      hydrated: hydrated ?? this.hydrated,
      version: version ?? this.version,
      selectedTab: selectedTab ?? this.selectedTab,
      organizations: organizations ?? this.organizations,
      organizationsSlugByProjectSlug: organizationsSlugByProjectSlug ?? this.organizationsSlugByProjectSlug,
      projectsByOrganizationSlug: projectsByOrganizationSlug ?? this.projectsByOrganizationSlug,
      projectsFetchedOnce: projectsFetchedOnce ?? this.projectsFetchedOnce,
      projectsLoading: projectsLoading ?? this.projectsLoading,
      projects: projects ?? this.projects,
      latestReleasesByProjectId: latestReleasesByProjectId ?? this.latestReleasesByProjectId,
      sessionsByProjectId: sessionsByProjectId ?? this.sessionsByProjectId,
      sessionsBeforeByProjectId: sessionsBeforeByProjectId ?? this.sessionsBeforeByProjectId,
      crashFreeSessionsByProjectId: crashFreeSessionsByProjectId ?? this.crashFreeSessionsByProjectId,
      crashFreeSessionsBeforeByProjectId: crashFreeSessionsBeforeByProjectId ?? this.crashFreeSessionsBeforeByProjectId,
      crashFreeUsersByProjectId: crashFreeUsersByProjectId ?? this.crashFreeUsersByProjectId,
      crashFreeUsersBeforeByProjectId: crashFreeUsersBeforeByProjectId ?? this.crashFreeUsersBeforeByProjectId,
      apdexByProjectId: apdexByProjectId ?? this.apdexByProjectId,
      apdexBeforeByProjectId: apdexBeforeByProjectId ?? this.apdexBeforeByProjectId,
      issuesByProjectSlug: issuesByProjectSlug ?? this.issuesByProjectSlug,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedProject: selectedProject ?? this.selectedProject,
      me: me ?? this.me
    );
  }

  Map<String, SessionState> sessionStateByProjectId(Set<SessionStatus> sessionStatus) {
    final sessionStateByProjectId = <String, SessionState>{};

    for (final projectId in sessionsByProjectId.keys) {
      final sessions = sessionsByProjectId[projectId];
      final previousSession = sessionsBeforeByProjectId[projectId];

      var total = 0;
      var previousTotal = 0;

      var lineChartPoints = <LineChartPoint>[];
      var previousLineChartPoints = <LineChartPoint>[];

      if (sessions != null) {
        final totalAndPoints = createTotalSessionCountAndLinePoints(sessionStatus, sessions);
        total = totalAndPoints[0] as int;
        lineChartPoints = totalAndPoints[1] as List<LineChartPoint>;
      }

      if (previousSession != null) {
        final totalAndPoints = createTotalSessionCountAndLinePoints(sessionStatus, previousSession);
        previousTotal = totalAndPoints[0] as int;
        previousLineChartPoints = totalAndPoints[1] as List<LineChartPoint>;
      }

      if (sessions != null) {
        sessionStateByProjectId[projectId] = SessionState(
          projectId: projectId,
          numberOfSessions: total,
          previousNumberOfSessions: previousTotal,
          sessionPoints: lineChartPoints,
          previousSessionPoints: previousLineChartPoints
        );
      }
    }
    return sessionStateByProjectId;
  }

  // Returns the total number of sessions and the line chart points for individual intervals.
  List<dynamic> createTotalSessionCountAndLinePoints(Set<SessionStatus> sessionStatus, Sessions sessions) {
    final groups = sessions.groups.where((element) =>
        sessionStatus.contains(element.by.sessionStatus)
    ).toList();

    var total = 0;
    for (final group in groups) {
      total += group.totals.sumSession;
    }

    final lineChartPoints = <LineChartPoint>[];
    for (var index = 0; index < sessions.intervals.length; index++) {
      final interval = sessions.intervals[index];
      var sum = 0;

      for (final group in groups) {
        sum += group.series.sumSession[index];
      }
      lineChartPoints.add(
        LineChartPoint(
          interval.millisecondsSinceEpoch.toDouble(),
          sum.toDouble()
        )
      );
    }
    return [total, lineChartPoints];
  }

  Organization organizationForProjectSlug(String projectSlug) {
    final organizationSlug = organizationsSlugByProjectSlug[projectSlug];
    if (organizationSlug != null) {
      return organizations.firstWhere((element) => element.slug == organizationSlug);
    } else {
      return null;
    }
  }

  List<ProjectWithLatestRelease> projectsWithLatestReleases() {
    return projects.map((project) => ProjectWithLatestRelease(project, latestReleasesByProjectId[project.id])).toList();
  }
}
