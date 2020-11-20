import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:sentry_mobile/redux/state/app_state.dart';
import 'project_picker_view_model.dart';

class ProjectPicker extends StatefulWidget {
  @override
  _ProjectPickerState createState() => _ProjectPickerState();
}

class _ProjectPickerState extends State<ProjectPicker> {

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects')
      ),
      body: Center(),
    );
  }
}