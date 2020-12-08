import 'dart:io';

import 'package:sentry_mobile/types/project_with_latest_release.dart';

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

class FetchOrganizationsAndProjectsAction {
  FetchOrganizationsAndProjectsAction();
}

class FetchOrganizationsAndProjectsSuccessAction {
  FetchOrganizationsAndProjectsSuccessAction(this.organizations, this.projectsByOrganizationId);
  final List<Organization> organizations;
  final Map<String, List<Project>> projectsByOrganizationId;
}

class FetchOrganizationsAndProjectsFailureAction {
  FetchOrganizationsAndProjectsFailureAction(this.error);
  final dynamic error;
}

class SelectOrganizationAction {
  SelectOrganizationAction(this.organziation);
  final Organization organziation;
}

// FetchProjectsAction

class FetchProjectsAction {
  FetchProjectsAction(this.organization);
  final Organization organization;
}

class FetchProjectsSuccessAction {
  FetchProjectsSuccessAction(this.organizationSlug, this.projects);
  final String organizationSlug;
  final List<Project> projects;
}

class FetchProjectsFailureAction {
  FetchProjectsFailureAction(this.error);
  final dynamic error;
}

// SelectProjectAction

class SelectProjectAction {
  SelectProjectAction(this.project);
  final Project project;
}

// FetchLatestReleasesAction

class FetchLatestReleasesAction {
  FetchLatestReleasesAction(this.projectsByOrganizationSlug);
  final Map<String, List<Project>> projectsByOrganizationSlug;
}

class FetchLatestReleasesSuccessAction {
  FetchLatestReleasesSuccessAction(this.projectsWithLatestReleases);
  final List<ProjectWithLatestRelease> projectsWithLatestReleases;
}

class FetchLatestReleasesFailureAction {
  FetchLatestReleasesFailureAction(this.error);
  final dynamic error;
}

// FetchReleaseAction

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