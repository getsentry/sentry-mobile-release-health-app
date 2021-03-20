// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return Author(
    json['id'] as String?,
    json['name'] as String?,
    json['email'] as String?,
    json['avatarUrl'] as String?,
    json['avatar'] == null
        ? null
        : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'avatar': instance.avatar,
    };
