import 'package:redux/redux.dart';

import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';

import 'project_picker_item.dart';

class ProjectPickerViewModel {
  ProjectPickerViewModel.fromStore(Store<AppState> store) {
    final List<ProjectPickerItem> items = [];
    for (final Organization organization in store.state.globalState.organizations) {
        final organizationProjects = store.state.globalState.projectsByOrganizationId[organization.id] ?? [];
        if (organizationProjects.isNotEmpty) {
          items.add(
              ProjectPickerOrganizationItem(
                  organization.id,
                  organization.name
              )
          );
          for (final Project organizationProject in organizationProjects) {
            items.add(
                ProjectPickerProjectItem(
                    organizationProject.id,
                    organizationProject.name,
                    store.state.globalState.selectedProjectIds.contains(organizationProject.id)
                )
            );
          }
        }
    }
    this.items = items;
  }

  List<ProjectPickerItem> items = [];

}

