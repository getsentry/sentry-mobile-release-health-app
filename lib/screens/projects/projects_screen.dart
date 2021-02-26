import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/actions.dart';
import '../../redux/state/app_state.dart';
import '../../screens/projects/project_item.dart';
import '../../screens/settings/settings_header.dart';
import '../../utils/sentry_colors.dart';
import 'projects_screen_view_model.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  
  @override
  Widget build(BuildContext context) {
     return StoreProvider<AppState>(
       store: StoreProvider.of(context),
       child: StoreConnector<AppState, ProjectPickerViewModel>(
          converter: (appState) => ProjectPickerViewModel.fromStore(appState),
          builder: (context, viewModel) => _content(viewModel),
          onInitialBuild: (viewModel) => StoreProvider.of<AppState>(context)
             .dispatch(FetchOrganizationsAndProjectsAction(false, false)),
       ),
     );
  }

  Widget _content(ProjectPickerViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Projects')
      ),
      body: viewModel.items.isEmpty
        ? Center(
          child: Text(
            'You have no projects with session data.',
            style: Theme.of(context).textTheme.subtitle1
          ),
        )
        : ListView.builder(
          itemCount: viewModel.items.length,
          itemBuilder: (context, index) {
            final item = viewModel.items[index];
            if (item is ProjectPickerHeadlineItem) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Text(
                    item.text,
                    style: Theme.of(context).textTheme.caption,
                  )
              );
            }
            else if (item is ProjectPickerOrganizationItem) {
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
                      color: SentryColors.revolver
                  ),
                ),
                trailing: Icon(
                  item.isBookmarked ? Icons.star : Icons.star_border,
                  color: item.isBookmarked ? SentryColors.lightningYellow : SentryColors.graySuit,
                ),
                onTap: () {
                  viewModel.toggleBookmark(index);
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