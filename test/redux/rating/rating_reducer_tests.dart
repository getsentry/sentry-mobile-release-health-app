import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_mobile/redux/rating/rating_actions.dart';
import 'package:sentry_mobile/redux/rating/rating_reducer.dart';
import 'package:sentry_mobile/redux/rating/rating_state.dart';

void main() {
  group('RatingReducer', () {
    test('app start action increments app start', () {
      final state = RatingState.initial();
      final action = RatingActionAppStart();
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 1);
    });

    test('rating presentation needed after 10 app starts', () {
      final state = RatingState.initial().copyWith(
        appStarts: 9
      );
      final action = RatingActionAppStart();
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
      final action = RatingActionRatingPresentation(dateTime);
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 0);
      expect(reducedState.needsRatingPresentation, false);
      expect(reducedState.lastRatingPresentation, dateTime);
    });

    test('no rating presentation needed when already presented for app starts', () {
      final state = RatingState.initial().copyWith(
        appStarts: 9,
        lastRatingPresentation: DateTime.now()
      );
      final action = RatingActionAppStart();
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 10);
      expect(reducedState.needsRatingPresentation, false);
    });

    test('rating presentation needed after 10 app starts and three months', () {
      final state = RatingState.initial().copyWith(
        appStarts: 9,
        lastRatingPresentation: DateTime.now().subtract(const Duration(days: 91))
      );
      final action = RatingActionAppStart();
      final reducedState = ratingReducer(state, action);
      expect(reducedState.appStarts, 10);
      expect(reducedState.needsRatingPresentation, true);
    });
  });
}
