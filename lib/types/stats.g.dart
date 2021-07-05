// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) {
  return Stats(
    (json['24h'] as List?)
        ?.map((e) => Stat.fromJson(e as List? ?? []))
        .toList(),
    (json['14d'] as List?)
        ?.map((e) => Stat.fromJson(e as List? ?? []))
        .toList(),
  );
}

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      '24h': instance.stats24h,
      '14d': instance.stats14d,
    };
