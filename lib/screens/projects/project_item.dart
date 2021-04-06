


class ProjectItem {
}

class ProjectHeadlineItem extends ProjectItem {
  ProjectHeadlineItem(this.text);
  final String text;
}

class ProjectOrganizationItem extends ProjectItem {
  ProjectOrganizationItem(this.title);
  final String title;
}

class ProjectProjectItem extends ProjectItem {
  ProjectProjectItem(this.organizationSlug, this.projectSlug, this.isBookmarked);

  final String organizationSlug;
  final String projectSlug;
  final bool isBookmarked;
}
