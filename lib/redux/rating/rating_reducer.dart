
import 'package:sentry_mobile/redux/rating/rating_actions.dart';

import 'rating_state.dart';

RatingState ratingReducer(RatingState state, dynamic action) {

  if (action is RatingActionAppStart) {
    final appStarts = state.appStarts + 1;
    final now = DateTime.now();
    final threeMonthsAgo = now.add(Duration(days: -90));
    final lastRatingPresentation = state.lastRatingPresentation;
    final enoughTimePassed = lastRatingPresentation == null
        || lastRatingPresentation.millisecondsSinceEpoch < threeMonthsAgo.millisecondsSinceEpoch;
    return state.copyWith(
        appStarts: appStarts,
        needsRatingPresentation: appStarts >= 10 && enoughTimePassed
    );
  } else if (action is RatingActionRatingPresentation) {
    return state.copyWith(
        appStarts: 0,
        needsRatingPresentation: false,
        lastRatingPresentation: action.date
    );
  }
  return state;
}
