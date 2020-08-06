import 'dart:io';

import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';

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
      this.selectedOrganization,
      this.organizations,
      this.projects,
      this.selectedTab,
      this.selectedProject});

  factory GlobalState.initial() {
    return GlobalState(
      hydrated: false,
      session: null,
      organizations: [],
      selectedOrganization: null,
      projects: [],
      selectedTab: 0,
      selectedProject: null,
    );
  }

  final Cookie session;
  final bool hydrated;
  final int selectedTab;

  final List<Organization> organizations;
  final Organization selectedOrganization;

  final List<Project> projects;
  final Project selectedProject;

  GlobalState copyWith({
    Cookie session,
    bool hydrated,
    int selectedTab,
    bool setSessionNull = false,
    List<Organization> organizations,
    Organization selectedOrganization,
    List<Project> projects,
    Project selectedProject,
  }) {
    return GlobalState(
      hydrated: hydrated ?? this.hydrated,
      selectedTab: selectedTab ?? this.selectedTab,
      session: setSessionNull ? null : (session ?? this.session),
      organizations: organizations ?? this.organizations,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
    );
  }
}
