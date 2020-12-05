import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/organization_slug_with_project_id.dart';

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
                  organization.name
              )
          );
          for (final Project organizationProject in organizationProjects) {
            final organizationSlugWithProjectId = OrganizationSlugWithProjectId(organization.slug, organizationProject.id, organizationProject.slug);
            items.add(
              ProjectPickerProjectItem(
                organizationSlugWithProjectId,
                organizationProject.name,
                store.state.globalState.selectedOrganizationSlugsWithProjectId.contains(organizationSlugWithProjectId)
              )
            );
          }
        }
    }
    this.items = items;
  }
  List<ProjectPickerItem> items = [];
}

