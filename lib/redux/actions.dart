import 'dart:io';

import '../types/organization.dart';
import '../types/project.dart';
import '../types/release.dart';

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
  FetchOrganizationsFailureAction(this.error);
  final dynamic error;
}

class SelectOrganizationAction {
  SelectOrganizationAction(this.organziation);
  final Organization organziation;
}

class FetchProjectsAction {
  FetchProjectsAction(this.organization);
  final Organization organization;
}

class FetchProjectsSuccessAction {
  FetchProjectsSuccessAction(this.organizationId, this.projects);
  final String organizationId;
  final List<Project> projects;
}

class FetchProjectsFailureAction {
  FetchProjectsFailureAction(this.error);
  final dynamic error;
}

class SelectProjectAction {
  SelectProjectAction(this.projectId);
  final String projectId;
}

class SelectProjectsAction {
  SelectProjectsAction(this.projectIds);
  final List<String> projectIds;
}

class FetchReleasesAction {
  FetchReleasesAction(this.organizationSlug, this.projectId);
  final String organizationSlug;
  final String projectId;
}

class FetchReleasesSuccessAction {
  FetchReleasesSuccessAction(this.payload);
  final List<Release> payload;
}

class FetchReleasesFailureAction {
  FetchReleasesFailureAction(this.error);
  final dynamic error;
}

class FetchReleaseAction {
  FetchReleaseAction(this.projectId, this.releaseId);
  final String projectId;
  final String releaseId;
}

class FetchReleaseSuccessAction {
  FetchReleaseSuccessAction(this.payload);
  final Release payload;
}

class FetchReleaseFailureAction {
  FetchReleaseFailureAction(this.error);
  final dynamic error;
}