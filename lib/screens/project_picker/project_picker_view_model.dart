import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

class ProjectPickerViewModel {
  ProjectPickerViewModel();

  static ProjectPickerViewModel fromStore(Store<AppState> store) =>
      ProjectPickerViewModel();
}