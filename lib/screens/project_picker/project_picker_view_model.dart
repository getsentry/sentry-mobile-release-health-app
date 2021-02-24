import 'package:redux/redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';

import 'project_picker_item.dart';

class ProjectPickerViewModel {
  ProjectPickerViewModel.fromStore(Store<AppState> store) {
    final List<ProjectPickerItem> items = [];
    for (final Organization organization in store.state.globalState.organizations) {
        final organizationProjects = store.state.globalState.projectsByOrganizationSlug[organization.slug]
            .where((element) => element.latestRelease != null).toList()
            ?? [];
        organizationProjects.sort((Project a, Project b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        if (organizationProjects.isNotEmpty) {
          items.add(
              ProjectPickerOrganizationItem(
                  organization.name
              )
          );
          for (final Project organizationProject in organizationProjects) {
            items.add(
              ProjectPickerProjectItem(
                organization.slug,
                organizationProject.slug,
                organizationProject.slug,
                organizationProject.isBookmarked,
                store.state.globalState.projectIdsWithSessions.contains(organizationProject.id)
              )
            );
          }
        }
    }

    if (items.isNotEmpty) {
      items.insert(0, ProjectPickerHeadlineItem(
        'Bookmarked project are shown before others on the main screen. '
        'Additionally, only projects with sessions in the last 90 days are shown.')
      );
    }
    _store = store;
    this.items = items;
  }
  Store<AppState> _store;
  List<ProjectPickerItem> items = [];

  void toggleBookmark(int index) {
    final item = items[index] as ProjectPickerProjectItem;
    if (item != null) {
      _store.dispatch(
          BookmarkProjectAction(
              item.organizationSlug,
              item.projectSlug,
              !item.isBookmarked
          )
      );
    }
  }
}

