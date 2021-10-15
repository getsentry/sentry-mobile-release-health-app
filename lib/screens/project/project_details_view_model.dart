import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

class ProjectDetailsViewModel {

  ProjectDetailsViewModel.from(this.projectId, Store<AppState> store) {
    title = 'Project Title';
  }

  String projectId = '';
  String title = '';

}
