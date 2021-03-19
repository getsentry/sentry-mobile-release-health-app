// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=2.9

part of 'session_group_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionGroupSeries _$SessionGroupSeriesFromJson(Map<String, dynamic> json) {
  return SessionGroupSeries(
    (json['sum(session)'] as List)?.map((e) => e as int)?.toList(),
    (json['count_unique(user)'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$SessionGroupSeriesToJson(SessionGroupSeries instance) =>
    <String, dynamic>{
      'sum(session)': instance.sumSession,
      'count_unique(user)': instance.countUniqueUsers,
    };
