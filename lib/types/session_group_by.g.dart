// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_group_by.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionGroupBy _$SessionGroupByFromJson(Map<String, dynamic> json) {
  return SessionGroupBy(
    _$enumDecodeNullable(_$SessionStatusEnumMap, json['session.status']),
    json['project'] as int?,
  );
}

Map<String, dynamic> _$SessionGroupByToJson(SessionGroupBy instance) =>
    <String, dynamic>{
      'session.status': _$SessionStatusEnumMap[instance.sessionStatus],
      'project': instance.project,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$SessionStatusEnumMap = {
  SessionStatus.healthy: 'healthy',
  SessionStatus.errored: 'errored',
  SessionStatus.crashed: 'crashed',
  SessionStatus.abnormal: 'abnormal',
};
