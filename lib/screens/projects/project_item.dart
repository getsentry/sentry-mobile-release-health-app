// @dart=2.9


class ProjectPickerItem {
}

class ProjectPickerHeadlineItem extends ProjectPickerItem {
  ProjectPickerHeadlineItem(this.text);
  final String text;
}

class ProjectPickerOrganizationItem extends ProjectPickerItem {
  ProjectPickerOrganizationItem(this.title);
  final String title;
}

class ProjectPickerProjectItem extends ProjectPickerItem {
  ProjectPickerProjectItem(this.organizationSlug, this.projectSlug, this.isBookmarked);

  final String organizationSlug;
  final String projectSlug;
  final bool isBookmarked;
}
