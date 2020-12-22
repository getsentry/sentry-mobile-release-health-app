import 'dart:io';

import 'package:sentry_mobile/types/group.dart';
import 'package:sentry_mobile/types/stats.dart';

import '../../issues.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/project_with_latest_release.dart';

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
      this.handledIssuesByProjectSlug,
      this.unhandledIssuesByProjectSlug,
      this.selectedOrganization,
      this.selectedProject});

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
      handledIssuesByProjectSlug: {},
      unhandledIssuesByProjectSlug: {},
      selectedOrganization: null,
      selectedProject: null,
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

  final Map<String, List<Group>> handledIssuesByProjectSlug;
  final Map<String, List<Group>> unhandledIssuesByProjectSlug;

  final Organization selectedOrganization;
  final Project selectedProject;

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
    Map<String, List<Group>> handledIssuesByProjectSlug,
    Map<String, List<Group>> unhandledIssuesByProjectSlug,
    Organization selectedOrganization,
    Project selectedProject,
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
      handledIssuesByProjectSlug: handledIssuesByProjectSlug ?? this.handledIssuesByProjectSlug,
      unhandledIssuesByProjectSlug: unhandledIssuesByProjectSlug ?? this.unhandledIssuesByProjectSlug,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedProject: selectedProject ?? this.selectedProject
    );
  }

  Map<String, List<Project>> bookmarkedProjectsByOrganizationSlug() {
    final Map<String, List<Project>> bookmarkedProjectsByOrganizationSlug = {};

    for (final organization in organizations) {
      final bookmarkedProjects = (projectsByOrganizationSlug[organization.slug] ?? []).where((element) => element.isBookmarked);
      if (bookmarkedProjects.isNotEmpty && organization.slug != null) {
        bookmarkedProjectsByOrganizationSlug[organization.slug] = bookmarkedProjects.toList();
      }
    }
    return bookmarkedProjectsByOrganizationSlug;
  }

  Map<String, Stats> aggregatedStatsByProjectSlug(bool handled) {
    final aggregatedStatsByProjectSlug = <String, Stats>{};
    if (handled) {
      handledIssuesByProjectSlug.forEach((key, value) => {
        aggregatedStatsByProjectSlug[key] = Stats.aggregated(value.map((e) => e.stats).toList())
      });
    } else {
      unhandledIssuesByProjectSlug.forEach((key, value) => {
        aggregatedStatsByProjectSlug[key] = Stats.aggregated(value.map((e) => e.stats).toList())
      });
    }
    return aggregatedStatsByProjectSlug;
  }
}
