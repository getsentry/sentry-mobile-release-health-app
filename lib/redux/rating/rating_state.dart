class RatingState {
  RatingState({
    required this.appStarts,
    required this.userDidInteract,
    required this.lastRatingPresentation,
    required this.needsRatingPresentation,
  });

  factory RatingState.initial() {
    return RatingState(
      appStarts: 0,
      userDidInteract: false,
      lastRatingPresentation: null,
      needsRatingPresentation: false,
    );
  }

  final int appStarts;
  final bool userDidInteract;
  final DateTime? lastRatingPresentation;
  final bool needsRatingPresentation;

  RatingState copyWith({
    int? appStarts,
    bool? userDidInteract,
    DateTime? lastRatingPresentation,
    bool? needsRatingPresentation,
  }) {
    return RatingState(
      appStarts: appStarts ?? this.appStarts,
      userDidInteract: userDidInteract ?? this.userDidInteract,
      lastRatingPresentation:
          lastRatingPresentation ?? this.lastRatingPresentation,
      needsRatingPresentation:
          needsRatingPresentation ?? this.needsRatingPresentation,
    );
  }
}
