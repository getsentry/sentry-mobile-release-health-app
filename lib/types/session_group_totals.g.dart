// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=2.9

part of 'session_group_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionGroupTotals _$SessionGroupTotalsFromJson(Map<String, dynamic> json) {
  return SessionGroupTotals(
    json['sum(session)'] as int,
    json['count_unique(user)'] as int,
  );
}

Map<String, dynamic> _$SessionGroupTotalsToJson(SessionGroupTotals instance) =>
    <String, dynamic>{
      'sum(session)': instance.sumSession,
      'count_unique(user)': instance.countUniqueUsers,
    };
