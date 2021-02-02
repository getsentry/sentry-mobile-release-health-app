import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../redux/state/app_state.dart';
import '../../screens/empty/empty_screen.dart';
import 'health_card.dart';
import 'health_divider.dart';
import 'health_screen_view_model.dart';
import 'project_card.dart';
import 'sessions_chart_row.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key key}) : super(key: key);

  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int _index;

  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HealthScreenViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => HealthScreenViewModel.fromStore(store),
    );
  }

  Widget _content(HealthScreenViewModel viewModel) {
    viewModel.fetchProjectsIfNeeded();

    if (viewModel.showProjectEmptyScreen || viewModel.showReleaseEmptyScreen) {
      _index = 0;

      String text = '';
      if (viewModel.showProjectEmptyScreen) {
        text = 'You need at least one project to use this view.';
      }
      if (viewModel.showReleaseEmptyScreen) {
        text = 'You need at least one release in you projects to use this view.';
      }
      return EmptyScreen(
        title: 'Remain Calm',
        text: text,
        button: 'Visit sentry.io',
        action: () async {
          const url = 'https://sentry.io';
          if (await canLaunch(url)) {
            await launch(url);
          }
        }
      );
    } else if (viewModel.showLoadingScreen || viewModel.projects.isEmpty) {
      _index = 0;

      return Center(
        child: CircularProgressIndicator(),
      );
    } else {

      WidgetsBinding.instance.addPostFrameCallback( ( Duration duration ) {
        if (viewModel.showLoadingScreen) {
          _refreshKey.currentState.show();
        } else {
          _refreshKey.currentState.deactivate();
        }
      });

      final updateIndex = (int index) {
        viewModel.fetchDataForProject(index);
        _index = index;
      };

      if (_index == null) {
        updateIndex(0);
      } else {
        updateIndex(_index);
      }

      return RefreshIndicator(
        key: _refreshKey,
        backgroundColor: Colors.white,
        color: Color(0xff81B4FE),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: viewModel.projects.length,
                          controller: PageController(viewportFraction: 0.9),
                          onPageChanged: (int index) => setState(() => updateIndex(index)),
                          itemBuilder: (context, index) {
                            final projectWitLatestRelease = viewModel.projects[index];
                            return ProjectCard(
                                projectWitLatestRelease.project,
                                projectWitLatestRelease.release,
                                viewModel.sessionStateForProject(projectWitLatestRelease.project)
                            );
                          },
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 22, left: 22, right: 22),
                      child: Column(
                        children: [
                          HealthDivider(
                            onSeeAll: () {},
                            title: 'Charts',
                          ),
                          SessionsChartRow(
                            title: 'Issues',
                            sessionState: viewModel.handledAndCrashedSessionStateForProject(viewModel.projects[_index].project),
                          ),
                          SessionsChartRow(
                            title: 'Crashes',
                            sessionState: viewModel.crashedSessionStateForProject(viewModel.projects[_index].project),
                            parentPoints: viewModel.handledAndCrashedSessionStateForProject(viewModel.projects[_index].project)?.points,
                          ),
                          HealthDivider(
                            onSeeAll: () {},
                            title: 'Statistics',
                          ),
                          Row(
                            children: [
                              HealthCard(
                                  title: 'Stability Score',
                                  viewModel: viewModel.stabilityScoreForProject(viewModel.projects[_index]?.project),
                              ),
                              HealthCard(
                                title: 'Apdex',
                                viewModel: viewModel.apdexForProject(viewModel.projects[_index]?.project),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
        onRefresh: () => Future.delayed(
          Duration(microseconds: 100),
          () { viewModel.fetchProjects(); }
        ),
      );
    }
  }
}
