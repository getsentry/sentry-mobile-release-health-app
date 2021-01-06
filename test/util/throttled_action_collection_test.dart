
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/utils/throttled_action_collection.dart';

void main() {
  group('ThrottledAction', () {
    test('hashCode', () {
      expect(Test('a').hashCode, equals(Test('a').hashCode));
    });

    test('length', () {
      final collection = ThrottledActionCollection();

      collection.insert(Test('a'));
      expect(collection.length, equals(1));

      collection.insert(Test('b'));
      expect(collection.length, equals(2));
    });

    test('contains true with different instance & same hashValue', () {
      final collection = ThrottledActionCollection();
      collection.insert(Test('a'));

      expect(collection.contains(Test('a')), equals(true));
    });

    test('cannot add instances with same hashValue multiple times', () {
      final collection = ThrottledActionCollection();
      collection.insert(Test('a'));
      collection.insert(Test('a'));
      collection.insert(Test('a'));

      expect(collection.length, equals(1));
    });

    test('remove', () {
      final collection = ThrottledActionCollection();
      collection.insert(Test('a'));
      collection.remove(Test('a'));

      expect(collection.length, equals(0));
    });

    test('clear', () {
      final collection = ThrottledActionCollection();
      collection.insert(Test('a'));
      collection.insert(Test('b'));
      collection.insert(Test('c'));

      collection.clear();

      expect(collection.length, equals(0));
    });
  });
}

class Test extends ThrottledAction {
  Test(this.value);
  final String value;

  @override
  List<Object> get props => [value];

  @override
  bool get stringify => false;
}