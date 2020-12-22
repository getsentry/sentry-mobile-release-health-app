import 'dart:io';

import 'package:sentry_mobile/types/group.dart';

import '../types/organization.dart';
import '../types/project.dart';
import '../types/project_with_latest_release.dart';

class RehydrateAction {
  RehydrateAction();
}

class SwitchTabAction {
  SwitchTabAction(this.selectedTab);
  final int selectedTab;
}

class LoginAction {
  LoginAction(this.cookie);
  final Cookie cookie;
}

class LogoutAction {
  LogoutAction();
}

// FetchOrganizationsAndProjects

class FetchOrganizationsAndProjectsAction {
  FetchOrganizationsAndProjectsAction();
}

class FetchOrganizationsAndProjectsSuccessAction {
  FetchOrganizationsAndProjectsSuccessAction(this.organizations, this.projectsByOrganizationSlug);
  final List<Organization> organizations;
  final Map<String, List<Project>> projectsByOrganizationSlug;
}

class FetchOrganizationsAndProjectsFailureAction {
  FetchOrganizationsAndProjectsFailureAction(this.error);
  final dynamic error;
}

// FetchLatestReleases

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

// FetchIssues

class FetchIssuesAction {
  FetchIssuesAction(this.organizationSlug, this.projectSlug, this.unhandled);
  final String organizationSlug;
  final String projectSlug;
  final bool unhandled;
}

class FetchIssuesSuccessAction {
  FetchIssuesSuccessAction(this.projectSlug, this.unhandled, this.issues);
  final String projectSlug;
  final bool unhandled;
  final List<Group> issues;
}

class FetchIssuesFailureAction {
  FetchIssuesFailureAction(this.error);
  final dynamic error;
}

// SelectOrganization

class SelectOrganizationAction {
  SelectOrganizationAction(this.organization);
  final Organization organization;
}

// SelectProject

class SelectProjectAction {
  SelectProjectAction(this.project);
  final Project project;
}