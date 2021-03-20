


class Stat {
  Stat(this.timestamp, this.value);
  Stat.fromJson(List json)
      : timestamp = json.map((e) => e as int).first,
        value = json.map((e) => e as int).last;

  int timestamp;
  int value;

  @override
  String toString() {
    return 'Stat(timestamp: $timestamp, value: $value)';
  }
}