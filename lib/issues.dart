import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'api/sentry_api.dart';
import 'issue_screen.dart';
import 'redux/state/app_state.dart';
import 'types/group.dart';
import 'types/organization.dart';
import 'types/project.dart';

Future<List<Group>> fetchGroups(
    String orgSlug, String projSlug, Cookie? cookie) async {
  final api = SentryApi(null);
  try {
    return await api.issues(organizationSlug: orgSlug, projectSlug: projSlug);
  } catch (exception) {
    rethrow;
  } finally {
    api.close();
  }
}

class IssuesScreenBuilder extends StatelessWidget {
  const IssuesScreenBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'Issues',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'Issues':
            return MaterialPageRoute<dynamic>(
                builder: (context) => IssuesScreen(), settings: settings);

          case 'Event':
            return MaterialPageRoute<dynamic>(
                builder: (context) => IssueScreen(), settings: settings);

          default:
            throw Exception('Invalid route');
        }
      },
    );
  }
}

class IssuesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IssuesViewModel>(
      converter: (store) => IssuesViewModel.fromStore(store),
      builder: (_, viewModel) => IssuesScreenStateWrapper(viewModel: viewModel),
    );
  }
}

class IssuesViewModel {
  IssuesViewModel(
      {required this.selectedOrganization,
      required this.selectedProject,
      required this.sessionCookie});

  final Organization? selectedOrganization;
  final Project? selectedProject;
  final Cookie? sessionCookie;

  static IssuesViewModel fromStore(Store<AppState> store) => IssuesViewModel(
      selectedOrganization: store.state.globalState.selectedOrganization,
      selectedProject: store.state.globalState.selectedProject,
      sessionCookie: null);
}

class IssuesScreenStateWrapper extends StatefulWidget {
  const IssuesScreenStateWrapper({Key? key, required this.viewModel})
      : super(key: key);

  final IssuesViewModel viewModel;

  @override
  _IssuesScreenState createState() => _IssuesScreenState(viewModel: viewModel);
}

class _IssuesScreenState extends State<IssuesScreenStateWrapper> {
  _IssuesScreenState({required this.viewModel});

  final IssuesViewModel viewModel;
  late Future<List<Group>> groupsFuture;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    setState(() {
      final selectedOrganizationSlug = viewModel.selectedOrganization?.slug;
      final selectedProjectSlug = viewModel.selectedProject?.slug;

      if (selectedOrganizationSlug != null && selectedProjectSlug != null) {
        groupsFuture = fetchGroups(selectedOrganizationSlug,
            selectedProjectSlug, viewModel.sessionCookie);
      } else {
        groupsFuture = Future.value(<Group>[]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: groupsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Group> groups = snapshot.data as List<Group>;

            if (groups.isEmpty) {
              return Center(
                  child: Text(
                'No issues',
                textAlign: TextAlign.center,
              ));
            } else {
              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Issue(
                      title: group.metadata?.type ?? 'Error',
                      value: group.title ?? '--',
                      culprit: group.culprit ?? '--',
                      userCount: group.userCount ?? 0,
                      count: group.count ?? '--',
                      lastSeen: group.lastSeen,
                      firstSeen: group.lastSeen);
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error fetching issues. Please try again.',
              textAlign: TextAlign.center,
            ));
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class Issue extends StatelessWidget {
  Issue(
      {required this.title,
      required this.value,
      required this.culprit,
      required this.userCount,
      required this.count,
      this.firstSeen,
      this.lastSeen});

  final String title;
  final String value;
  final String culprit;
  final int userCount;
  final String count;
  final DateTime? firstSeen;
  final DateTime? lastSeen;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => IssueScreen()));
      },
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(culprit, style: TextStyle(color: Colors.black54)),
                      Text(value, style: TextStyle(color: Colors.black87)),
                      if (lastSeen != null && firstSeen != null)
                        Text(
                            '${timeago.format(lastSeen!)} — ${timeago.format(firstSeen!)}',
                            style: TextStyle(color: Colors.black54))
                    ],
                  )),
              Row(
                children: <Widget>[
                  Container(
                      width: 48,
                      alignment: Alignment.centerRight,
                      child: Text(count,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      width: 48,
                      alignment: Alignment.centerRight,
                      child: Text(userCount.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              )
            ])),
      ));
}
