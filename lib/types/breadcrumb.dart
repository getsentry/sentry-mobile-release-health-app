import 'package:json_annotation/json_annotation.dart';

import 'package:sentry_mobile/utils/conversion.dart';

part 'breadcrumb.g.dart';

@JsonSerializable()
class Breadcrumb {
  Breadcrumb(
      {this.type,
      this.category,
      this.level,
      this.message,
      this.data,
      this.timestamp});

  factory Breadcrumb.fromJson(Map<String, dynamic> json) =>
      _$BreadcrumbFromJson(json);

  final String type;
  final String category;
  final String level;
  final String message;
  @JsonKey(fromJson: dateTimeFromString, toJson: dateTimeToString)
  final DateTime timestamp;
  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() => _$BreadcrumbToJson(this);
}
