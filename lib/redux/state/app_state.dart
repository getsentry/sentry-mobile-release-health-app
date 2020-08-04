import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      this.storage,
      this.selectedOrganization,
      this.organizations,
      this.projects,
      this.selectedProject});

  factory GlobalState.initial() {
    return GlobalState(
      session: null,
      storage: FlutterSecureStorage(),
      organizations: [],
      selectedOrganization: null,
      projects: [],
      selectedProject: null,
    );
  }

  final FlutterSecureStorage storage;
  final Cookie session;

  final List<Organization> organizations;
  final Organization selectedOrganization;

  final List<Project> projects;
  final Project selectedProject;

  GlobalState copyWith({
    Cookie session,
    bool setSessionNull = false,
    FlutterSecureStorage storage,
    List<Organization> organizations,
    Organization selectedOrganization,
    List<Project> projects,
    Project selectedProject,
  }) {
    return GlobalState(
      session: setSessionNull ? null : (session ?? this.session),
      storage: storage ?? this.storage,
      organizations: organizations ?? this.organizations,
      selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      projects: projects ?? this.projects,
      selectedProject: selectedProject ?? this.selectedProject,
    );
  }
}
