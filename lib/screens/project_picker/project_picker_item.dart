
import 'package:sentry_mobile/types/organization_slug_with_project_id.dart';

class ProjectPickerItem {
}

class ProjectPickerOrganizationItem extends ProjectPickerItem {
  ProjectPickerOrganizationItem(this.title);

  String title;
}

class ProjectPickerProjectItem extends ProjectPickerItem {
  ProjectPickerProjectItem(this.organizationSlugWithProjectId, this.title, this.selected);

  OrganizationSlugWithProjectId organizationSlugWithProjectId;
  String title;
  bool selected;
}