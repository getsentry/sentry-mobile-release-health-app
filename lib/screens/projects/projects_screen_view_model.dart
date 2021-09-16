import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';

import 'project_item.dart';

class ProjectsScreenViewModel {
  ProjectsScreenViewModel.fromStore(Store<AppState> store) {
    final List<ProjectItem> items = [];
    for (final Organization organization
        in store.state.globalState.organizations) {
      final organizationProjects = store.state.globalState
              .projectsByOrganizationSlug[organization.slug] ??
          [];
      final projectsWithSessions = organizationProjects
          .where((project) => store.state.globalState.projectIdsWithSessions
              .contains(project.id))
          .toList();
      projectsWithSessions.sort((Project a, Project b) {
        return a.name?.toLowerCase().compareTo(b.name?.toLowerCase() ?? '') ??
            0;
      });

      if (projectsWithSessions.isNotEmpty) {
        items.add(ProjectOrganizationItem(organization.name!));
        for (final Project project in projectsWithSessions) {
          items.add(ProjectProjectItem(project.platform, organization.slug,
              project.slug, project.isBookmarked ?? false));
        }
      }
    }

    if (items.isNotEmpty) {
      items.insert(
          0,
          ProjectHeadlineItem(
              'Bookmarked projects are shown before others on the main screen. '
              'Additionally, only projects with sessions in the last 90 days are shown.'));
    }
    _store = store;
    this.items = items;
  }
  late Store<AppState> _store;
  late List<ProjectItem> items;

  void toggleBookmark(int index) {
    final item = items[index] as ProjectProjectItem;
    _store.dispatch(BookmarkProjectAction(
        item.organizationSlug, item.projectSlug, !item.isBookmarked));
  }
}
