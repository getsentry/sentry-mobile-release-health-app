import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/rating/rating_reducer.dart';

import '../api/api_errors.dart';
import '../types/project.dart';
import '../types/release.dart';
import '../utils/collections.dart';
import '../utils/stability_score.dart';
import 'actions.dart';
import 'global/global_reducer.dart';
import 'state/app_state.dart';

AppState appReducer(AppState state, dynamic action) => AppState(
  globalState: globalReducer(state.globalState, action),
  ratingState: ratingReducer(state.ratingState, action),
);


