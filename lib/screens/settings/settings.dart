import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/settings/settings_header.dart';
import 'package:sentry_mobile/screens/settings/settings_view_model.dart';

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
    );
  }

  Widget _content(SettingsViewModel viewModel) {
    if (viewModel.organizations.isEmpty) {
      viewModel.fetchOrganizations();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SettingsHeader('Projects'),
          Center(
              child: DropdownButton<String>(
                value: viewModel.selectedOrganization?.id,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: viewModel.selectOrganization,
                items: viewModel.organizations
                    .map((e) => DropdownMenuItem<String>(
                  value: e.id,
                  child: Text(e.name),
                ))
                    .toList(),
              )),
          Center(
              child: DropdownButton<String>(
                value: viewModel.selectedProject?.id,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: viewModel.selectProject,
                items: viewModel.projects
                    .map((e) => DropdownMenuItem<String>(
                  value: e.id,
                  child: Text(e.name),
                ))
                    .toList(),
              )),
          RaisedButton(
            child: Text('Logout'),
            onPressed: () => viewModel.logout(),
          ),
        ],
      ),
    );
  }
}
