import 'dart:ffi';
import 'dart:io';

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
      this.selectedTab,
      this.organizations,
      this.organizationsSlugByProjectSlug,
      this.projectsByOrganizationSlug,
      this.projectsFetchedOnce,
      this.projectsLoading,
      this.projectsWithLatestReleases,
      this.releasesFetchedOnce,
      this.releasesLoading,
      this.sessionsByProjectId,
      this.sessionsBeforeByProjectId,
      this.stabilityScoreByProjectId,
      this.stabilityScoreBeforeByProjectId,
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
      selectedTab: 0,
      organizations: [],
      organizationsSlugByProjectSlug: {},
      projectsByOrganizationSlug: {},
      projectsFetchedOnce: false,
      projectsLoading: false,
      projectsWithLatestReleases: [],
      releasesFetchedOnce: false,
      releasesLoading: false,
      sessionsByProjectId: {},
      sessionsBeforeByProjectId: {},
      issuesByProjectSlug: {},
      stabilityScoreByProjectId: {},
      stabilityScoreBeforeByProjectId: {},
      apdexByProjectId: {},
      apdexBeforeByProjectId: {},
      selectedOrganization: null,
      selectedProject: null,
      me: null
    );
  }

  final Cookie session;
  final bool hydrated;
  final int selectedTab;

  final List<Organization> organizations;
  final Map<String, String> organizationsSlugByProjectSlug;
  final Map<String, List<Project>> projectsByOrganizationSlug;
  final bool projectsFetchedOnce;
  final bool projectsLoading;

  final List<ProjectWithLatestRelease> projectsWithLatestReleases;
  final bool releasesFetchedOnce;
  final bool releasesLoading;

  final Map<String, Sessions> sessionsByProjectId;
  final Map<String, Sessions> sessionsBeforeByProjectId; // Interval before sessionsByProjectId
  final Map<String, double> stabilityScoreByProjectId;
  final Map<String, double> stabilityScoreBeforeByProjectId; // Interval before stabilityScoreByProjectId
  final Map<String, double> apdexByProjectId;
  final Map<String, double> apdexBeforeByProjectId; // Interval before apdexByProjectId

  final Map<String, List<Group>> issuesByProjectSlug;

  final Organization selectedOrganization;
  final Project selectedProject;

  final User me;

  GlobalState copyWith({
    Cookie session,
    bool hydrated,
    int selectedTab,
    bool setSessionNull = false,
    List<Organization> organizations,
    final Map<String, String> organizationsSlugByProjectSlug,
    final Map<String, List<Project>> projectsByOrganizationSlug,
    bool projectsFetchedOnce,
    bool projectsLoading,
    List<ProjectWithLatestRelease> projectsWithLatestReleases,
    bool releasesFetchedOnce,
    bool releasesLoading,
    Map<String, Sessions> sessionsByProjectId,
    Map<String, Sessions> sessionsBeforeByProjectId,
    Map<String, double> stabilityScoreByProjectId,
    Map<String, double> stabilityScoreBeforeByProjectId,
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
      selectedTab: selectedTab ?? this.selectedTab,
      organizations: organizations ?? this.organizations,
      organizationsSlugByProjectSlug: organizationsSlugByProjectSlug ?? this.organizationsSlugByProjectSlug,
      projectsByOrganizationSlug: projectsByOrganizationSlug ?? this.projectsByOrganizationSlug,
      projectsFetchedOnce: projectsFetchedOnce ?? this.projectsFetchedOnce,
      projectsLoading: projectsLoading ?? this.projectsLoading,
      projectsWithLatestReleases: projectsWithLatestReleases ?? this.projectsWithLatestReleases,
      releasesFetchedOnce: releasesFetchedOnce ?? this.releasesFetchedOnce,
      releasesLoading: releasesLoading ?? this.releasesLoading,
      sessionsByProjectId: sessionsByProjectId ?? this.sessionsByProjectId,
      sessionsBeforeByProjectId: sessionsBeforeByProjectId ?? this.sessionsBeforeByProjectId,
      stabilityScoreByProjectId: stabilityScoreByProjectId ?? this.stabilityScoreByProjectId,
      stabilityScoreBeforeByProjectId: stabilityScoreBeforeByProjectId ?? this.stabilityScoreBeforeByProjectId,
      apdexByProjectId: apdexByProjectId ?? this.apdexByProjectId,
      apdexBeforeByProjectId: apdexBeforeByProjectId ?? this.apdexBeforeByProjectId,
      issuesByProjectSlug: issuesByProjectSlug ?? this.issuesByProjectSlug,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedProject: selectedProject ?? this.selectedProject,
      me: me ?? this.me
    );
  }

  // When there are no bookmarked projects, we return all of them.
  List<ProjectWithLatestRelease> allOrBookmarkedProjectsWithLatestReleases() {
    final List<ProjectWithLatestRelease> allProjectsWithLatestReleases = [];
    final List<ProjectWithLatestRelease> bookmarkedProjectsWithLatestReleases = [];

    for (final projectWithLatestRelease in projectsWithLatestReleases) {
      allProjectsWithLatestReleases.add(projectWithLatestRelease);
      if (projectWithLatestRelease.project.isBookmarked) {
        bookmarkedProjectsWithLatestReleases.add(projectWithLatestRelease);
      }
    }
    if (bookmarkedProjectsWithLatestReleases.isEmpty) {
      return allProjectsWithLatestReleases;
    } else {
      return bookmarkedProjectsWithLatestReleases;
    }
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
          sessionCount: total,
          previousSessionCount: previousTotal,
          points: lineChartPoints,
          previousPoints: previousLineChartPoints
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
    final organziationSlug = organizationsSlugByProjectSlug[projectSlug];
    if (organziationSlug != null) {
      return organizations.firstWhere((element) => element.slug == organziationSlug);
    } else {
      return null;
    }
  }
}
