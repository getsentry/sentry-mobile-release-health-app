import 'dart:io';

import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/release.dart';

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
      this.selectedProjectIds,
      this.releases,
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
      selectedProjectIds: <String>{},
      releases: [],
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
  final Set<String> selectedProjectIds;

  final List<Release> releases;
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
    Set<String> selectedProjectIds,
    List<Release> releases,
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
        selectedProjectIds: selectedProjectIds ?? this.selectedProjectIds,
      releases: releases ?? this.releases,
      releasesLoading: releasesLoading ?? this.releasesLoading
    );
  }
  
  List<Project> selectedProjects() {
    return projectsByOrganizationId.values
        .expand((element) => element)
        .where((element) => selectedProjectIds.contains(element.id))
        .toList();
  }
}
