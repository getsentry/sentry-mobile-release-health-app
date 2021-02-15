
class Cursor {
  Cursor(this.value, this.offset, this.previous);

  final int value;
  final int offset;
  final int previous;

  String queryKey() {
    return 'cursor';
  }

  String queryValue() {
    return '$value:$offset:$previous';
  }
}
