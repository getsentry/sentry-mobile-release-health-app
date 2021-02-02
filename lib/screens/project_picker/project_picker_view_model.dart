import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';

import 'project_picker_item.dart';

class ProjectPickerViewModel {
  ProjectPickerViewModel.fromStore(Store<AppState> store) {
    final List<ProjectPickerItem> items = [];
    for (final Organization organization in store.state.globalState.organizations) {
        final organizationProjects = store.state.globalState.projectsByOrganizationSlug[organization.slug] ?? [];
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
                organizationProject.isBookmarked
              )
            );
          }
        }
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

