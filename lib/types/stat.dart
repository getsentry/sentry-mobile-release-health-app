import 'package:json_annotation/json_annotation.dart';

class Stat {
  Stat.fromJson(List json)
      : timestamp = json.map((e) => e as int)?.first ?? 0,
        value = json.map((e) => e as int)?.last ?? 0;

  int timestamp;
  int value;
}