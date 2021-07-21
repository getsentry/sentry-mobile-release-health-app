class RatingState {
  RatingState({
    required this.appStarts,
    required this.lastRatingPresentation,
    required this.needsRatingPresentation,
  });

  factory RatingState.initial() {
    return RatingState(
      appStarts: 0,
      lastRatingPresentation: null,
      needsRatingPresentation: false,
    );
  }

  final int appStarts;
  final DateTime? lastRatingPresentation;
  final bool needsRatingPresentation;

  RatingState copyWith({
    int? appStarts,
    DateTime? lastRatingPresentation,
    bool? needsRatingPresentation,
  }) {
    return RatingState(
      appStarts: appStarts ?? this.appStarts,
      lastRatingPresentation: lastRatingPresentation ?? this.lastRatingPresentation,
      needsRatingPresentation: needsRatingPresentation ?? this.needsRatingPresentation,
    );
  }
}
