import 'dart:io';

import 'package:sentry_mobile/types/organization.dart';

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
  final List payload;
}

class FetchOrganizationsFailureAction {
  FetchOrganizationsFailureAction();
}

class SelectOrganizationsAction {
  SelectOrganizationsAction(this.payload);
  final Organization payload;
}