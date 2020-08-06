import 'dart:io';

import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';

class RehydrateAction {
  RehydrateAction();
}

class SwitchTabAction {
  SwitchTabAction(this.payload);
  final int payload;
}

class LoginAction {
  LoginAction(this.payload);
  final Cookie payload;
}

class LogoutAction {
  LogoutAction();
}

class TitleAction {
  TitleAction(this.payload);
  final String payload;
}

class FetchOrganizationsAction {
  FetchOrganizationsAction();
}

class FetchOrganizationsSuccessAction {
  FetchOrganizationsSuccessAction(this.payload);
  final List<Organization> payload;
}

class FetchOrganizationsFailureAction {
  FetchOrganizationsFailureAction();
}

class SelectOrganizationAction {
  SelectOrganizationAction(this.payload);
  final Organization payload;
}

class FetchProjectsAction {
  FetchProjectsAction(this.payload);
  final Organization payload;
}

class FetchProjectsSuccessAction {
  FetchProjectsSuccessAction(this.payload);
  final List<Project> payload;
}

class FetchProjectsFailureAction {
  FetchProjectsFailureAction();
}

class SelectProjectAction {
  SelectProjectAction(this.payload);
  final Project payload;
}