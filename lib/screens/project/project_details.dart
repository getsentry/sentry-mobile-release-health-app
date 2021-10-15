
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'project_details_view_model.dart';

class ProjectDetails extends StatefulWidget {

  ProjectDetails(this.projectId);
  final String projectId;

  @override
  State<StatefulWidget> createState() {
    return _ProjectDetailsState(projectId);
  }
}

class _ProjectDetailsState extends State<ProjectDetails> {

  _ProjectDetailsState(this.projectId);
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProjectDetailsViewModel>(
      converter: (store) => ProjectDetailsViewModel.from(projectId, store),
      builder: (_, viewModel) => _content(viewModel)
    );
  }

  Widget _content(ProjectDetailsViewModel viewModel) {
    return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.title),
        ),
      body: Center(
        child: Text('No project data.'),
      )
    );
  }
}
