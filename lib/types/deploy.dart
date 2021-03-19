// @dart=2.9


import 'package:json_annotation/json_annotation.dart';

part 'deploy.g.dart';

@JsonSerializable()
class Deploy {
  Deploy(this.environment, this.dateFinished);
  factory Deploy.fromJson(Map<String, dynamic> json) => _$DeployFromJson(json);

  final String environment;
  final DateTime dateFinished;

  Map<String, dynamic> toJson() => _$DeployToJson(this);
}
