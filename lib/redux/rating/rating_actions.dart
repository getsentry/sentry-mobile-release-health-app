
class RatingRehydrateAction {
  RatingRehydrateAction(
    this.appStarts,
    this.lastRatingPresentation,
  );
  final int appStarts;
  final DateTime? lastRatingPresentation;
}

class RatingAppStartAction {}

class RatingPresentationAction {
  RatingPresentationAction(
    this.date,
  );
  final DateTime date;
}
