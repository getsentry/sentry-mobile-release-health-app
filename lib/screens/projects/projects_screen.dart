import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/utils/platform_icons.dart';

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
      child: StoreConnector<AppState, ProjectsScreenViewModel>(
        converter: (appState) => ProjectsScreenViewModel.fromStore(appState),
        builder: (context, viewModel) => _content(viewModel),
        onInitialBuild: (viewModel) => StoreProvider.of<AppState>(context)
            .dispatch(FetchOrgsAndProjectsAction(false)),
      ),
    );
  }

  Widget _content(ProjectsScreenViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarked Projects')),
      body: viewModel.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'None of your projects have session data. Do you need to upgrade your SDK?',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                if (item is ProjectHeadlineItem) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Text(
                        item.text,
                        style: Theme.of(context).textTheme.caption,
                      ));
                } else if (item is ProjectOrganizationItem) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SettingsHeader(item.title));
                } else if (item is ProjectProjectItem) {
                  return ListTile(
                    contentPadding:
                        EdgeInsets.only(right: 16, top: 0, left: 16, bottom: 0),
                    title: Text(
                      item.projectSlug,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.apply(color: SentryColors.revolver),
                    ),
                    leading: _platformImage(item.platform),
                    trailing: Icon(
                      item.isBookmarked ? Icons.star : Icons.star_border,
                      color: item.isBookmarked
                          ? SentryColors.lightningYellow
                          : SentryColors.graySuit,
                    ),
                    onTap: () {
                      viewModel.toggleBookmark(index);
                    },
                  );
                } else {
                  throw Exception('Unknown list item type.');
                }
              }),
    );
  }

  Widget? _platformImage(String? platform) {
    const width = 22.0;
    const height = 22.0;
    Widget? platformImage;
    if (platform != null) {
      platformImage = PlatformIcons.svgPicture(platform, width, height);
    } else {
      platformImage = Container(
        width: width,
        height: height,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        child: Container(
          width: width,
          height: height,
          color: SentryColors.snuff,
          child: platformImage,
        ),
      ),
    );
  }
}
