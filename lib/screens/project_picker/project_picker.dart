import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/actions.dart';

import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/project_picker/project_picker_item.dart';
import 'package:sentry_mobile/screens/settings/settings_header.dart';
import 'project_picker_view_model.dart';

class ProjectPicker extends StatefulWidget {
  @override
  _ProjectPickerState createState() => _ProjectPickerState();
}

class _ProjectPickerState extends State<ProjectPicker> {

  var _fetchedOrganizationsAndProjects = false;

  @override
  Widget build(BuildContext context) {
     return StoreProvider<AppState>(
       store: StoreProvider.of(context),
       child: StoreConnector<AppState, ProjectPickerViewModel>(
          converter: (appState) => ProjectPickerViewModel.fromStore(appState),
          builder: (context, viewModel) => _content(viewModel)
       ),
     );
  }

  Widget _content(ProjectPickerViewModel viewModel) {

    if (!_fetchedOrganizationsAndProjects) {
      _fetchedOrganizationsAndProjects = true;
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(FetchOrganizationsAndProjectsAction());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Projects')
      ),
      body: ListView.builder(
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) {
            final item = viewModel.items[index];
            if (item is ProjectPickerOrganizationItem) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SettingsHeader(item.title)
              );
            } else if (item is ProjectPickerProjectItem) {
              return ListTile(
                  contentPadding: EdgeInsets.only(right: 16, top: 0, left: 16, bottom: 0),
                  title: Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyText1.apply(
                        color: Colors.black
                    ),
                  ),
                  trailing: Icon(
                    item.selected ? Icons.star : Icons.star_border,
                    color: item.selected ? Colors.orangeAccent : Colors.grey,
                  ),
                onTap: () {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(SelectProjectAction(item.organizationSlugWithProjectId));
                },
              );
            } else {
              throw Exception('Unknown list item type.');
            }
          }
      ),
    );
  }
}