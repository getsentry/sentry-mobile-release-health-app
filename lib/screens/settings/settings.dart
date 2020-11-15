import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/settings/settings_header.dart';
import 'package:sentry_mobile/screens/settings/settings_view_model.dart';
import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';

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

    final List<Widget> children = [];
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SettingsHeader('Projects'),
      )
    );
    if (viewModel.selectedProjects.isNotEmpty) {
      children.addAll(_buildProjects(viewModel));
    } else {
      children.add(
        Text(
          "No projects selected.",
          style: Theme.of(context).textTheme.bodyText1.apply(
              color: Colors.grey,
          )
        )
      );
    }

    children.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SettingsHeader('User'),
        )
    );
    children.add(
        RaisedButton(
          child: Text('Logout'),
          onPressed: () => viewModel.logout(),
        )
    );

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: children,
        ),
      ),
    );
  }

  List<Widget> _buildProjects(SettingsViewModel viewModel) {
    return viewModel.selectedProjects.map((project) => _buildProjectRow(project, viewModel.selectedOrganization)).toList();
  }

  Widget _buildProjectRow(Project project, Organization organization) {
    return ListTile(
      contentPadding: EdgeInsets.only(right: 16, top: 0, left: 16, bottom: 0),
      title: Text(
        project.name,
        style: Theme.of(context).textTheme.bodyText1.apply(
            color: Colors.black
        ),
      ),
      subtitle: Text(
        organization.name,
        style: Theme.of(context).textTheme.subtitle2.apply(
          color: Colors.black26
        ),
      ),
    );
  }
}
