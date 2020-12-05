
class ProjectPickerItem {
  String id;
}

class ProjectPickerOrganizationItem extends ProjectPickerItem {
  ProjectPickerOrganizationItem(this.id, this.title);

  @override
  String id;
  String title;
}

class ProjectPickerProjectItem extends ProjectPickerItem {
  ProjectPickerProjectItem(this.id, this.title, this.selected);

  @override
  String id;
  String title;
  bool selected;
}