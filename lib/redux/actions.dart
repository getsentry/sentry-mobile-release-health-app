import 'dart:io';

import 'package:equatable/equatable.dart';

import '../types/group.dart';
import '../types/organization.dart';
import '../types/project.dart';
import '../types/project_with_latest_release.dart';
import '../types/release.dart';
import '../types/user.dart';

abstract class ThrottledAction extends Equatable {
  
}

class RehydrateAction {
  RehydrateAction();
}

class RehydrateSuccessAction {
  RehydrateSuccessAction(this.cookie);
  final Cookie cookie;
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

class ApiFailureAction {
  ApiFailureAction(this.error);
  final dynamic error;
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

class FetchOrganizationsAndProjectsFailureAction extends ApiFailureAction {
  FetchOrganizationsAndProjectsFailureAction(error) : super(error);
}

// FetchLatestRelease

class FetchLatestReleaseAction extends ThrottledAction {
  FetchLatestReleaseAction(this.organizationSlug, this.projectSlug, this.projectId, this.releaseId);
  final String organizationSlug;
  final String projectSlug;
  final String projectId;
  final String releaseId;

  @override
  List<Object> get props => [organizationSlug, projectSlug, projectId, releaseId];

  @override
  bool get stringify => false;
}

class FetchLatestReleaseSuccessAction {
  FetchLatestReleaseSuccessAction(this.projectSlug, this.latestRelease);
  final String projectSlug;
  final Release latestRelease;
}

class FetchLatestReleaseFailureAction extends ApiFailureAction {
  FetchLatestReleaseFailureAction(error) : super(error);
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

class FetchLatestReleasesFailureAction extends ApiFailureAction {
  FetchLatestReleasesFailureAction(error) : super(error);
}

// FetchIssues

class FetchIssuesAction extends ThrottledAction {
  FetchIssuesAction(this.organizationSlug, this.projectSlug, this.unhandled);
  final String organizationSlug;
  final String projectSlug;
  final bool unhandled;

  @override
  List<Object> get props => [organizationSlug, projectSlug, unhandled];

  @override
  bool get stringify => false;
}

class FetchIssuesSuccessAction {
  FetchIssuesSuccessAction(this.projectSlug, this.unhandled, this.issues);
  final String projectSlug;
  final bool unhandled;
  final List<Group> issues;
}

class FetchIssuesFailureAction extends ApiFailureAction {
  FetchIssuesFailureAction(error) : super(error);
}

// FetchAuthenticatedUser

class FetchAuthenticatedUserAction {
  FetchAuthenticatedUserAction();
}

class FetchAuthenticatedUserSuccessAction {
  FetchAuthenticatedUserSuccessAction(this.me);
  final User me;
}

class FetchAuthenticatedUserFailureAction extends ApiFailureAction {
  FetchAuthenticatedUserFailureAction(error) : super(error);
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
