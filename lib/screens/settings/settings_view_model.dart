import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';

class SettingsViewModel {
  SettingsViewModel.from(Store<AppState> store) {
    session = store.state.globalState.session;
    final projects = store.state.globalState
        .bookmarkedProjectsByOrganizationSlug()
        .values.expand((element) => element).map((e) => e.name)
        .join(', ');

    bookmarkedProjects = projects.isNotEmpty ? projects : '--';
    logout = () {
      store.dispatch(LogoutAction());
    };
  }

  Cookie session;
  String bookmarkedProjects;
  Function() logout;

}