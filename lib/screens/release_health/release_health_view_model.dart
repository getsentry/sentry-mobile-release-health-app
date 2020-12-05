import 'package:redux/redux.dart';
import 'package:sentry_mobile/types/project_with_latest_release.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../types/organization.dart';
import '../../types/project.dart';
import '../../types/release.dart';

class ReleaseHealthViewModel {
  ReleaseHealthViewModel.fromStore(Store<AppState> store)
      : _store = store,
        releases = store.state.globalState.latestReleases,
        loading = store.state.globalState.releasesLoading && store.state.globalState.latestReleases.isEmpty;

  final Store<AppState> _store;

  final List<ProjectWithLatestRelease> releases;
  final bool loading;

  void fetchReleases() {
    _store.dispatch(FetchLatestReleasesAction(_store.state.globalState.selectedOrganizationSlugsWithProjectId.toList()));
  }
}
