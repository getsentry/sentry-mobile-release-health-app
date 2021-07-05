import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  Tag({this.value, this.key});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  final String? value;
  final String? key;

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
