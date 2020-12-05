import 'package:equatable/equatable.dart';

class OrganizationSlugWithProjectId extends Equatable {
  OrganizationSlugWithProjectId(this.organizationSlug, this.projectId, this.projectSlug);

  final String organizationSlug;
  final String projectId;
  final String projectSlug;

  @override
  List<Object> get props => [organizationSlug, projectId, projectSlug];
}