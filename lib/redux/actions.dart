import 'dart:io';

import 'package:sentry_mobile/types/project_with_latest_release.dart';

import '../types/organization.dart';
import '../types/organization_slug_with_project_id.dart';
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
  SelectProjectAction(this.organizationSlugWithProjectId);
  final OrganizationSlugWithProjectId organizationSlugWithProjectId;
}

class SelectProjectsAction {
  SelectProjectsAction(this.organizationSlugsWithProjectId);
  final List<OrganizationSlugWithProjectId> organizationSlugsWithProjectId;
}

class FetchLatestReleasesAction {
  FetchLatestReleasesAction(this.organizationSlugsWithProjectId);
  final List<OrganizationSlugWithProjectId> organizationSlugsWithProjectId;
}

class FetchReleasesSuccessAction {
  FetchReleasesSuccessAction(this.project, this.release);
  final Project project;
  final Release release;
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