import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/actions.dart';

import '../../redux/state/app_state.dart';
import '../../screens/debug/sentry_flutter_screen.dart';
import '../../screens/projects/projects_screen.dart';
import '../../utils/sentry_colors.dart';
import 'settings_header.dart';
import 'settings_view_model.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => SettingsViewModel.fromStore(store),
      onInitialBuild: (viewModel) => viewModel.fetchAuthenticatedUserIfNeeded()
    );
  }

  Widget _content(SettingsViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsHeader('Projects'),
              ),
              ListTile(
                title: Text(
                  'Bookmarked Projects',
                  style: Theme.of(context).textTheme.bodyText1.apply(
                    color: SentryColors.revolver
                  ),
                ),
                subtitle: Text(
                    viewModel.bookmarkedProjects,
                    style: Theme.of(context).textTheme.subtitle1.apply(
                        color: SentryColors.mamba
                    )
                ),
                leading: Icon(
                  Icons.star,
                  color: SentryColors.lightningYellow,
                ),
                onTap: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProjectsScreen()
                      ),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsHeader('Other'),
              ),
              SwitchListTile(
                title: Text(
                  'Sentry SDK',
                  style: Theme.of(context).textTheme.bodyText1.apply(
                      color: SentryColors.revolver
                  ),
                ),
                value: viewModel.sentrySdkEnabled,
                subtitle: Text(
                  viewModel.sentrySdkEnabled
                    ? 'Crash detection is enabled.'
                    : 'Help us improve the app by enabling crash detection.',
                  style: Theme.of(context).textTheme.subtitle1.apply(
                      color: SentryColors.mamba
                  )
                ),
                secondary: Icon(
                  Icons.bug_report_rounded,
                  color: SentryColors.burntSienna,
                ),
                onChanged: (bool value) {
                  StoreProvider.of<AppState>(context).dispatch(
                      SentrySdkToggleAction(value)
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Sign Out',
                  style: Theme.of(context).textTheme.bodyText1.apply(
                      color: SentryColors.revolver
                  ),
                ),
                subtitle: Text(
                  viewModel.userInfo,
                  style: Theme.of(context).textTheme.subtitle1.apply(
                      color: SentryColors.mamba
                  )
                ),
                leading: Icon(
                  Icons.exit_to_app,
                  color: SentryColors.royalBlue,
                ),
                onTap: () => Navigator.pop(context, true),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => SentryFlutterScreen()
                      ),
                    );
                  },
                  child: Text(
                    viewModel.version,
                    style: Theme.of(context).textTheme.caption)
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
