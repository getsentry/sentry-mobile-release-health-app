
import 'package:sentry_mobile/redux/actions.dart';

class ThrottledActionCollection {

  final _throttledActionsByHashCode = <int>{};

  int get length => _throttledActionsByHashCode.length;

  bool contains(ThrottledAction action) {
    return _throttledActionsByHashCode.contains(action.hashCode);
  }
  
  void insert(ThrottledAction action) {
    if (!_throttledActionsByHashCode.contains(action.hashCode)) {
      _throttledActionsByHashCode.add(action.hashCode);
    }
  }

  void remove(ThrottledAction action) {
    if (_throttledActionsByHashCode.contains(action.hashCode)) {
      _throttledActionsByHashCode.remove(action.hashCode);
    }
  }

  void clear() {
    _throttledActionsByHashCode.clear();
  }

}