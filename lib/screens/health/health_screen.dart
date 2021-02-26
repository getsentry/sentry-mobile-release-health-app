import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/state/app_state.dart';
import '../../screens/empty/empty_screen.dart';
import '../../types/session_status.dart';
import '../../utils/sentry_colors.dart';
import 'health_card.dart';
import 'health_divider.dart';
import 'health_screen_view_model.dart';
import 'sessions_chart_row.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key key}) : super(key: key);

  @override
  _HealthScreenState createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int _index;

  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HealthScreenViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => HealthScreenViewModel.fromStore(store),
      onInitialBuild: (viewModel) => viewModel.fetchProjects(),
    );
  }

  Widget _content(HealthScreenViewModel viewModel) {
    if (viewModel.showLoadingScreen) {
      return Scaffold(body:
      Center(child:
        Column(
            mainAxisAlignment : MainAxisAlignment.center,
            crossAxisAlignment : CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(value: viewModel.loadingProgress),
              Container(
                  padding: EdgeInsets.only(top: 16, left: 22, right: 22),
                  child: Text(viewModel.loadingText ?? 'Loading ...')
              )
        ])
      ));
    } else if (viewModel.showProjectEmptyScreen) {
      return EmptyScreen(
        title: 'No projects found',
        text: 'You need at least one project with session data to use this view.',
        button: 'Refresh',
        action: viewModel.fetchProjects
      );
    } else
      if (viewModel.showErrorScreen) {
      return EmptyScreen(
          title: 'Error',
          text: 'Something went wrong. Please try again.',
          button: 'Retry',
          action: viewModel.fetchProjects
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
      }

      return RefreshIndicator(
        key: _refreshKey,
        backgroundColor: Colors.white,
        color: Color(0xff81B4FE),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            _pageController = PageController(viewportFraction: (MediaQuery.of(context).size.width - 32) / MediaQuery.of(context).size.width);

            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 22, right: 22),
                      child: HealthDivider(
                        onSeeAll: () {},
                        title: 'in the last 24 hours',
                      ),
                    ),
                    SizedBox(
                        height: 208,
                        child: PageView.builder(
                          itemCount: viewModel.projects.length,
                          controller: _pageController,
                          onPageChanged: (int index) {
                            setState(() {
                              updateIndex(index);
                              // Fetch next projects at end
                              if (index == viewModel.projects.length - 1) {
                                viewModel.fetchProjects();
                              }
                            });
                          },
                          itemBuilder: (context, index) {
                            return viewModel.projectCard(index);
                          },
                        )),
                    Container(
                      padding: EdgeInsets.only(top: 8, left: 22, right: 22),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HealthCard(
                                  title: 'Crash Free Sessions',
                                  viewModel: viewModel.crashFreeSessionsForProject(_index),
                                ),
                                SizedBox(width: 8),
                                HealthCard(
                                  title: 'Crash Free Users',
                                  viewModel: viewModel.crashFreeUsersForProject(_index),
                                ),
                              ],
                            ),
                          ),
                          SessionsChartRow(
                            title: 'Healthy',
                            color: SentryColors.buttercup,
                            sessionState: viewModel.sessionState(_index, SessionStatus.healthy),
                            flipDeltaColors: true,
                          ),
                          SessionsChartRow(
                            title: 'Errored',
                            color: SentryColors.eastBay,
                            sessionState: viewModel.sessionState(_index, SessionStatus.errored),
                          ),
                          if (viewModel.showAbnormalSessions(_index))
                            SessionsChartRow(
                              title: 'Abnormal',
                              color: SentryColors.tapestry,
                              sessionState: viewModel.sessionState(_index, SessionStatus.abnormal),
                            ),
                          SessionsChartRow(
                            title: 'Crashed',
                            color: SentryColors.burntSienna,
                            sessionState: viewModel.sessionState(_index, SessionStatus.crashed),
                          ),
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
          () {
            viewModel.reloadProjects();
            setState(() {
              updateIndex(0);
              _pageController.jumpToPage(0);
            });
          }
        ),
      );
    }
  }
}
