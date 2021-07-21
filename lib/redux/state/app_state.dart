import '../global/global_state.dart';
import '../rating/rating_state.dart';

class AppState {
  AppState({
    required this.globalState,
    required this.ratingState,
  });

  factory AppState.initial() {
    return AppState(
      globalState: GlobalState.initial(),
      ratingState: RatingState.initial(),
    );
  }

  final GlobalState globalState;
  final RatingState ratingState;

  AppState copyWith({GlobalState? globalState, RatingState? ratingState}) {
    return AppState(
      globalState: globalState ?? this.globalState,
      ratingState: ratingState ?? this.ratingState,
    );
  }
}
