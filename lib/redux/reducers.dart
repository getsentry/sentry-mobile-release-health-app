import 'package:sentry_mobile/redux/rating/rating_reducer.dart';

import 'global/global_reducer.dart';
import 'state/app_state.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
  globalState: globalReducer(state.globalState, action),
  ratingState: ratingReducer(state.ratingState, action),
);


