// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionGroup _$SessionGroupFromJson(Map<String, dynamic> json) {
  return SessionGroup(
    json['by'] == null
        ? null
        : SessionGroupBy.fromJson(json['by'] as Map<String, dynamic>),
    json['totals'] == null
        ? null
        : SessionGroupTotals.fromJson(json['totals'] as Map<String, dynamic>),
    json['series'] == null
        ? null
        : SessionGroupSeries.fromJson(json['series'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SessionGroupToJson(SessionGroup instance) =>
    <String, dynamic>{
      'by': instance.by,
      'totals': instance.totals,
      'series': instance.series,
    };
