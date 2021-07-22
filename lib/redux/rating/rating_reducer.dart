import 'rating_actions.dart';
import 'rating_state.dart';

RatingState ratingReducer(RatingState state, dynamic action) {
  if (action is RatingRehydrateAction) {
    return _evaluate(state.copyWith(
      appStarts: action.appStarts,
      lastRatingPresentation: action.lastRatingPresentation,
    ));
  }
  if (action is RatingUserInteractionAction) {
    return _evaluate(state.copyWith(userDidInteract: true));
  } else if (action is RatingPresentationAction) {
    return state.copyWith(
        appStarts: 0,
        needsRatingPresentation: false,
        lastRatingPresentation: action.date);
  }
  return state;
}

RatingState _evaluate(RatingState state) {
  final now = DateTime.now();
  final threeMonthsAgo = now.add(Duration(days: -90));
  final lastRatingPresentation = state.lastRatingPresentation;
  final enoughTimePassed = lastRatingPresentation == null ||
      lastRatingPresentation.millisecondsSinceEpoch <
          threeMonthsAgo.millisecondsSinceEpoch;
  return state.copyWith(
      needsRatingPresentation:
          state.appStarts >= 10 && state.userDidInteract && enoughTimePassed);
}
