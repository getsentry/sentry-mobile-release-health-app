

import 'package:json_annotation/json_annotation.dart';

part 'organization.g.dart';

@JsonSerializable()
class Organization {
  Organization(this.id, this.name, this.slug, this.apdexThreshold);

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

  final String? id;
  final String? name;
  final String? slug;
  final int? apdexThreshold;

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}