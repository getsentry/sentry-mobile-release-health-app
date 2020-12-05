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
    this.organizations,
    this.fetchOrganizations,
    this.selectedProjects
  });

  final Cookie session;

  final Function(Cookie session) login;
  final Function() logout;

  final List<Organization> organizations;
  final Function() fetchOrganizations;

  final List<Project> selectedProjects;

  static SettingsViewModel fromStore(Store<AppState> store) =>
      SettingsViewModel(
        session: store.state.globalState.session,
        login: (Cookie session) {
          store.dispatch(LoginAction(session));
          store.dispatch(FetchOrganizationsAction());
        },
        logout: () {
          store.dispatch(LogoutAction());
        },
        organizations: store.state.globalState.organizations,
        fetchOrganizations: () {
          store.dispatch(FetchOrganizationsAction());
        },
        selectedProjects: store.state.globalState.selectedProjects(),
      );
}