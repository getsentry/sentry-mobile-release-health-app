// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_group_by.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionGroupBy _$SessionGroupByFromJson(Map<String, dynamic> json) {
  return SessionGroupBy(
    _$enumDecodeNullable(_$SessionStatusEnumMap, json['session.status']),
    json['project'] as int,
  );
}

Map<String, dynamic> _$SessionGroupByToJson(SessionGroupBy instance) =>
    <String, dynamic>{
      'session.status': _$SessionStatusEnumMap[instance.sessionStatus],
      'project': instance.project,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SessionStatusEnumMap = {
  SessionStatus.healthy: 'healthy',
  SessionStatus.errored: 'errored',
  SessionStatus.crashed: 'crashed',
  SessionStatus.abnormal: 'abnormal',
};
