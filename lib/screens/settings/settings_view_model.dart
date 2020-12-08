import 'dart:io';

import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';

class SettingsViewModel {
  SettingsViewModel({
    this.session,
    this.logout,
    this.organizations,
    this.fetchOrganizations,
    this.selectedProjects
  });

  final Cookie session;

  final Function() logout;

  final List<Organization> organizations;
  final Function() fetchOrganizations;

  final List<Project> selectedProjects;

  static SettingsViewModel fromStore(Store<AppState> store) =>
      SettingsViewModel(
        session: store.state.globalState.session,
        logout: () {
          store.dispatch(LogoutAction());
        },
        organizations: store.state.globalState.organizations,
        fetchOrganizations: () {
          store.dispatch(FetchOrganizationsAndProjectsAction());
        },
        selectedProjects: store.state.globalState.selectedProjects(),
      );
}