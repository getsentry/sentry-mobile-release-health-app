import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

import 'breadcrumb_viewer.dart';
import 'context_view.dart';
import 'redux/state/app_state.dart';
import 'text_theme_ext.dart';
import 'types/breadcrumb.dart';
import 'types/event.dart';
import 'types/group.dart';
import 'types/organization.dart';
import 'types/tag.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({Key key}) : super(key: key);

  @override
  _IssueState createState() => _IssueState();
}

Future<Group> fetchGroup() async {
  final response =
      await http.get('https://jennmueng.com/sentry_sample_issue.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;
    return Group.fromJson(responseJson);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Release');
  }
}

Future<Event> fetchEvent() async {
  final response =
      await http.get('https://jennmueng.com/sentry_sample_event.json');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;
    return Event.fromJson(responseJson);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Release');
  }
}

class IssueViewModel {
  IssueViewModel({@required this.selectedOrganization});
  final Organization selectedOrganization;

  static IssueViewModel fromStore(Store<AppState> store) => IssueViewModel(
      selectedOrganization: store.state.globalState.selectedOrganization);
}

class _IssueState extends State<IssueScreen> {
  Future<Event> futureEvent;
  Future<Group> futureGroup;

  @override
  void initState() {
    super.initState();
    getSampleData();
  }

  void getSampleData() {
    setState(() {
      futureEvent = fetchEvent();
      futureGroup = fetchGroup();
    });
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: Future.wait<dynamic>([futureEvent, futureGroup]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final event = snapshot.data[0] as Event;
            final group = snapshot.data[1] as Group;

            return StoreConnector<AppState, IssueViewModel>(
                converter: (store) => IssueViewModel.fromStore(store),
                builder: (context, viewModel) => IssueView(
                    latestEvent: event, group: group, viewModel: viewModel));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class IssueView extends StatelessWidget {
  IssueView(
      {@required this.latestEvent,
      @required this.group,
      @required this.viewModel});
  final Event latestEvent;
  final Group group;
  final IssueViewModel viewModel;

  /// Launches the issue in a web browser.
  Future<void> launchEventUrl() async {
    final url =
        'https://sentry.io/organizations/${viewModel.selectedOrganization.slug}/issues/${latestEvent.groupID}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    List<Breadcrumb> breadcrumbs = [];

    latestEvent.entries.forEach((entry) {
      if (entry['type'] == 'breadcrumbs') {
        List<dynamic> d = entry['data']['values'] as List<dynamic>;

        breadcrumbs = d
            .map((dynamic b) => Breadcrumb.fromJson(b as Map<String, dynamic>))
            .toList();
      }
    });

    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 40),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(latestEvent.metadata.type,
                            style: Theme.of(context).textTheme.headline1),
                        Text(latestEvent.culprit,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .fontSize)),
                        Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Text(latestEvent.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .fontSize)))
                      ],
                    )),
                EventCounts(
                    count: group.count, userCount: group.userCount.toString()),
                Tags(tags: latestEvent.tags),
                BreadcrumbViewer(breadcrumbs: breadcrumbs),
                Container(
                    margin: EdgeInsets.only(top: 14),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).primaryColorLight),
                    )),
                    child: Column(
                      children: [
                        IssueSeenRelease(
                            title: 'Last Seen',
                            version: group.lastRelease.version,
                            when: timeago.format(group.lastSeen),
                            time: group.lastSeen.toString()),
                        IssueSeenRelease(
                            title: 'First Seen',
                            version: group.firstRelease.version,
                            when: timeago.format(group.firstSeen),
                            time: group.firstSeen.toString()),
                      ],
                    )),
                Contexts(eventContext: latestEvent.context),
                RaisedButton(
                    onPressed: launchEventUrl, child: Text('Open in Browser')),
              ],
            )));
  }
}

class Tags extends StatelessWidget {
  Tags({@required this.tags});
  final List<Tag> tags;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        margin: EdgeInsets.only(top: 18, bottom: 4),
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 8),
                alignment: Alignment.topLeft,
                child:
                    Text('TAGS', style: Theme.of(context).textTheme.caption)),
            Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 8.0, // gap between lines,
                runAlignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: tags
                    .map((Tag tag) =>
                        TagCard(tagKey: tag.key, tagValue: tag.value))
                    .toList()),
          ],
        ));
  }
}

class TagCard extends StatelessWidget {
  TagCard({@required this.tagKey, @required this.tagValue});

  final String tagKey;
  final String tagValue;

  Widget build(BuildContext context) {
    return Container(
      height: 26,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(
            color: Color(0xffc6becf),
            width: 1,
          )),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  height: 26,
                  alignment: Alignment.centerRight,
                  child: Text(tagKey),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 1.0, color: Color(0xffc6becf)),
                    ),
                    color: Color(0xfffaf9fb),
                  )),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(tagValue,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.code.fontFamily,
                          color: Theme.of(context).primaryColorDark))),
            ],
          )),
    );
  }
}

class EventCounts extends StatelessWidget {
  EventCounts({this.count, this.userCount});

  final String count;
  final String userCount;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 14, left: 16, right: 16),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(3)),
            border: Border.all(
              color: Color(0xffc6becf),
              width: 1,
            )),
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          EventCount(title: "Events", value: count),
          EventCount(title: "Users", value: userCount)
        ]));
  }
}

class EventCount extends StatelessWidget {
  EventCount({this.title, this.value});

  final String title;
  final String value;

  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.caption),
            Text(value,
                style: TextStyle(
                    fontSize: 22, color: Theme.of(context).primaryColorDark))
          ],
        ));
  }
}

class Contexts extends StatelessWidget {
  Contexts({@required this.eventContext});

  final Map<String, dynamic> eventContext;

  Widget build(BuildContext context) {
    List<Widget> contexts = new List<Widget>();

    eventContext.forEach((title, dynamic value) =>
        contexts.add(ContextView(title: title, value: value)));

    return Container(
      child: Column(children: contexts),
    );
  }
}

class IssueSeenRelease extends StatelessWidget {
  IssueSeenRelease({this.title, this.version, this.when, this.time});
  final String title;
  final String version;
  final String when;
  final String time;

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 14),
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(title, style: Theme.of(context).textTheme.caption)),
            Container(
                padding: EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("When"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text(when), Text(time)],
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Release"), Text(version)],
            )
          ],
        ));
  }
}
