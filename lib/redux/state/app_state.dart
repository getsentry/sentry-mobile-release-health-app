import 'dart:io';

import 'package:sentry_mobile/types/project_with_latest_release.dart';

import '../../types/organization.dart';
import '../../types/organization_slug_with_project_id.dart';
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
      this.selectedOrganization,
      this.selectedProject,
      this.selectedOrganizationSlugsWithProjectId,
      this.latestReleases,
      this.releasesLoading});

  factory GlobalState.initial() {
    return GlobalState(
      session: null,
      hydrated: false,
      selectedTab: 0,
      organizations: [],
      projectsByOrganizationId: {},
      selectedOrganization: null,
      selectedProject: null,
      selectedOrganizationSlugsWithProjectId: <OrganizationSlugWithProjectId>{},
      latestReleases: [],
      releasesLoading: false
    );
  }

  final Cookie session;
  final bool hydrated;
  final int selectedTab;

  final List<Organization> organizations;
  final Map<String, List<Project>> projectsByOrganizationId;

  final Organization selectedOrganization;
  final Project selectedProject;
  final Set<OrganizationSlugWithProjectId> selectedOrganizationSlugsWithProjectId;

  final List<ProjectWithLatestRelease> latestReleases;
  final bool releasesLoading;

  GlobalState copyWith({
    Cookie session,
    bool hydrated,
    int selectedTab,
    bool setSessionNull = false,
    List<Organization> organizations,
    final Map<String, List<Project>> projectsByOrganizationId,
    Organization selectedOrganization,
    Project selectedProject,
    Set<OrganizationSlugWithProjectId> selectedOrganizationSlugsWithProjectId,
    List<ProjectWithLatestRelease> latestReleases,
    bool releasesLoading
  }) {
    return GlobalState(
      session: setSessionNull ? null : (session ?? this.session),
      hydrated: hydrated ?? this.hydrated,
      selectedTab: selectedTab ?? this.selectedTab,
      organizations: organizations ?? this.organizations,
      projectsByOrganizationId: projectsByOrganizationId ?? this.projectsByOrganizationId,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedProject: selectedProject ?? this.selectedProject,
      selectedOrganizationSlugsWithProjectId: selectedOrganizationSlugsWithProjectId ?? this.selectedOrganizationSlugsWithProjectId,
      latestReleases: latestReleases ?? this.latestReleases,
      releasesLoading: releasesLoading ?? this.releasesLoading
    );
  }
  
  List<Project> selectedProjects() {
    return projectsByOrganizationId.values
        .expand((element) => element)
        .where((element) => selectedOrganizationSlugsWithProjectId.map((e) => e.projectId).contains(element.id))
        .toList();
  }
  
  
}

