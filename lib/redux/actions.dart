import '../types/cursor.dart';
import '../types/group.dart';
import '../types/organization.dart';
import '../types/project.dart';
import '../types/project_with_latest_release.dart';
import '../types/release.dart';
import '../types/sessions.dart';
import '../types/user.dart';

class RehydrateAction {
  RehydrateAction();
}

class RehydrateSuccessAction {
  RehydrateSuccessAction(this.authToken, this.version);
  final String authToken;
  final String version;
}

class SwitchTabAction {
  SwitchTabAction(this.selectedTab);
  final int selectedTab;
}

class LoginAction {
  LoginAction(this.authToken);
  final String authToken;
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
  FetchOrganizationsAndProjectsAction(this.pagination, this.reload);
  final bool pagination;
  final bool reload;
}

class FetchOrganizationsAndProjectsSuccessAction {
  FetchOrganizationsAndProjectsSuccessAction(this.organizations, this.projectsByOrganizationSlug, this.projectCursorsByOrganizationSlug, this.reload);
  final List<Organization> organizations;
  final Map<String, List<Project>> projectsByOrganizationSlug;
  final Map<String, Cursor> projectCursorsByOrganizationSlug;
  final bool reload;
}

class FetchOrganizationsAndProjectsFailureAction extends ApiFailureAction {
  FetchOrganizationsAndProjectsFailureAction(error) : super(error);
}

// FetchLatestRelease

class FetchLatestReleaseAction {
  FetchLatestReleaseAction(this.organizationSlug, this.projectSlug, this.projectId, this.releaseId);
  final String organizationSlug;
  final String projectSlug;
  final String projectId;
  final String releaseId;
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

class FetchIssuesAction {
  FetchIssuesAction(this.organizationSlug, this.projectSlug);
  final String organizationSlug;
  final String projectSlug;
}

class FetchIssuesSuccessAction {
  FetchIssuesSuccessAction(this.projectSlug, this.issues);
  final String projectSlug;
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

// FetchSessions

class FetchSessionsAction {
  FetchSessionsAction(this.organizationSlug, this.projectId);

  final String organizationSlug;
  final String projectId;
}

class FetchSessionsSuccessAction {
  FetchSessionsSuccessAction(this.projectId, this.sessions, this.sessionsBefore);
  final String projectId;
  final Sessions sessions;
  final Sessions sessionsBefore;
}

class FetchSessionsFailureAction extends ApiFailureAction {
  FetchSessionsFailureAction(error) : super(error);
}

<<<<<<< HEAD
// FetchSessions

class BookmarkProjectAction {
  BookmarkProjectAction(this.organizationSlug, this.projectSlug, this.bookmarked);

  final String organizationSlug;
  final String projectSlug;
  final bool bookmarked;
}

class BookmarkProjectSuccessAction {
  BookmarkProjectSuccessAction(this.organizationSlug, this.project);

  final String organizationSlug;
  final Project project;
}

class BookmarkProjectFailureAction extends ApiFailureAction {
  BookmarkProjectFailureAction(error) : super(error);

// FetchApDex

class FetchApdexAction {
  FetchApdexAction(this.apdexThreshold, this.organizationSlug, this.projectId);

  final int apdexThreshold;
  final String organizationSlug;
  final String projectId;
}

class FetchApdexSuccessAction {
  FetchApdexSuccessAction(this.projectId, this.apdex, this.apdexBefore);

  final String projectId;
  final double apdex;
  final double apdexBefore;
}

class FetchApdexFailureAction extends ApiFailureAction {
  FetchApdexFailureAction(error) : super(error);
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
