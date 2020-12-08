import 'dart:io';

import 'package:sentry_mobile/types/project_with_latest_release.dart';

import '../../types/organization.dart';
import '../../types/project.dart';

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
      this.projectsByOrganizationId,
      this.projectsLoading,
      this.projectsWithLatestReleases,
      this.releasesLoading,
      this.selectedOrganization,
      this.selectedProject});

  factory GlobalState.initial() {
    return GlobalState(
      session: null,
      hydrated: false,
      selectedTab: 0,
      organizations: [],
      projectsByOrganizationId: {},
      projectsLoading: false,
      projectsWithLatestReleases: [],
      releasesLoading: false,
      selectedOrganization: null,
      selectedProject: null,
    );
  }

  final Cookie session;
  final bool hydrated;
  final int selectedTab;

  final List<Organization> organizations;
  final Map<String, List<Project>> projectsByOrganizationId;
  final bool projectsLoading;

  final List<ProjectWithLatestRelease> projectsWithLatestReleases;
  final bool releasesLoading;

  final Organization selectedOrganization;
  final Project selectedProject;

  GlobalState copyWith({
    Cookie session,
    bool hydrated,
    int selectedTab,
    bool setSessionNull = false,
    List<Organization> organizations,
    final Map<String, List<Project>> projectsByOrganizationId,
    bool projectsLoading,
    List<ProjectWithLatestRelease> projectsWithLatestReleases,
    bool releasesLoading,
    Organization selectedOrganization,
    Project selectedProject,
  }) {
    return GlobalState(
      session: setSessionNull ? null : (session ?? this.session),
      hydrated: hydrated ?? this.hydrated,
      selectedTab: selectedTab ?? this.selectedTab,
      organizations: organizations ?? this.organizations,
      projectsByOrganizationId: projectsByOrganizationId ?? this.projectsByOrganizationId,
      projectsLoading: projectsLoading ?? this.projectsLoading,
      projectsWithLatestReleases: projectsWithLatestReleases ?? this.projectsWithLatestReleases,
      releasesLoading: releasesLoading ?? this.releasesLoading,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedProject: selectedProject ?? this.selectedProject
    );
  }

  Map<String, List<Project>> bookmarkedProjectsByOrganizationSlug() {
    final Map<String, List<Project>> bookmarkedProjectsByOrganizationSlug = {};

    for (final organization in organizations) {
      final bookmarkedProjects = (projectsByOrganizationId[organization.id] ?? []).where((element) => element.isBookmarked);
      if (bookmarkedProjects.isNotEmpty && organization.slug != null) {
        bookmarkedProjectsByOrganizationSlug[organization.slug] = bookmarkedProjects.toList();
      }
    }
    return bookmarkedProjectsByOrganizationSlug;
  }

  List<Project> selectedProjects() {
    return [];
  }
}

