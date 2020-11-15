import 'dart:io';

import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';

class SettingsViewModel {
  SettingsViewModel({
    this.session,
    this.login,
    this.logout,
    this.fetchOrganizations,
    this.organizations,
    this.selectOrganization,
    this.selectedOrganization,
    this.projects,
    this.selectProject,
    this.selectedProject,
    this.selectedProjects
  });

  final Cookie session;

  final Function(Cookie session) login;
  final Function() logout;

  final Function() fetchOrganizations;
  final List<Organization> organizations;
  final Function(String id) selectOrganization;
  final Organization selectedOrganization;

  final List<Project> projects;
  final Function(String id) selectProject;
  final Project selectedProject;

  final List<Project> selectedProjects;

  static SettingsViewModel fromStore(Store<AppState> store) =>
      SettingsViewModel(
        // Login / Session
        session: store.state.globalState.session,
        login: (Cookie session) {
          store.dispatch(LoginAction(session));
          store.dispatch(FetchOrganizationsAction());
        },
        logout: () {
          print('LOGOUT');
          store.dispatch(LogoutAction());
        },
        // Organizations
        fetchOrganizations: () {
          store.dispatch(FetchOrganizationsAction());
        },
        organizations: store.state.globalState.organizations,
        selectOrganization: (String id) {
          final org = store.state.globalState.organizations
              .firstWhere((o) => o.id == id, orElse: () => null);
          if (org != null) {
            store.dispatch(SelectOrganizationAction(org));
            store.dispatch(FetchProjectsAction(org));
          }
        },
        selectedOrganization: store.state.globalState.selectedOrganization,
        // Projects
        projects: store.state.globalState.projects,
        selectProject: (String id) {
          final proj = store.state.globalState.projects
              .firstWhere((o) => o.id == id, orElse: () => null);
          if (proj != null) {
            store.dispatch(SelectProjectAction(proj));
          }
        },
        selectedProject: store.state.globalState.selectedProject,
        selectedProjects: store.state.globalState.selectedProjects ?? [],
      );
}