import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_mobile/redux/rating/rating_actions.dart';
import 'package:sentry_mobile/redux/rating/rating_reducer.dart';
import 'package:sentry_mobile/redux/rating/rating_state.dart';

void main() {
  group('RatingReducer', () {

    test('rehydrate', () {
      final state = RatingState.initial();
      final dateTime = DateTime.now();
      final action = RatingRehydrateAction(9, dateTime);
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 9);
      expect(reducedState.lastRatingPresentation, dateTime);
    });

    test('rating presentation needed after 10 app starts', () {
      final state = RatingState.initial();
      final action = RatingRehydrateAction(10, null);
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 10);
      expect(reducedState.needsRatingPresentation, true);
    });

    test('rating presentation mutates appStarts, needsRatingPresentation and lastRatingPresentation', () {
      final state = RatingState.initial().copyWith(
        appStarts: 10,
        needsRatingPresentation: true,
      );
      final dateTime = DateTime.now();
      final action = RatingPresentationAction(dateTime);
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 0);
      expect(reducedState.needsRatingPresentation, false);
      expect(reducedState.lastRatingPresentation, dateTime);
    });

    test('no rating presentation needed when already presented for app starts', () {
      final state = RatingState.initial();
      final action = RatingRehydrateAction(10, DateTime.now());
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 10);
      expect(reducedState.needsRatingPresentation, false);
    });

    test('rating presentation needed after 10 app starts and three months', () {
      final state = RatingState.initial();
      final action = RatingRehydrateAction(
        10,
        DateTime.now().subtract(const Duration(days: 91)),
      );
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 10);
      expect(reducedState.needsRatingPresentation, true);
    });

    test('rating presentation needed after 10 rehydrate', () {
      final state = RatingState.initial();
      final action = RatingRehydrateAction(10, null);
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 10);
      expect(reducedState.needsRatingPresentation, true);
    });
  });
}
