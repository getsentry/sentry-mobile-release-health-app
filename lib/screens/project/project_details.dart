
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';
import 'package:sentry_mobile/screens/health/health_card.dart';
import 'package:sentry_mobile/screens/platform/platform_image.dart';
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
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(viewModel.title),
              PlatformImage(viewModel.platform, 3),
            ]
          )
        ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HealthCard(
                  title: 'Crash Free Sessions',
                  viewModel: viewModel
                      .crashFreeSessions(),
                ),
                SizedBox(width: 8),
                HealthCard(
                  title: 'Crash Free Users',
                  viewModel:
                  viewModel.crashFreeUsers(),
                ),
              ],
            )
          ],
        )
      )
    );
  }
}
