import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'redux/state/app_state.dart';

class ProjectSelector extends StatefulWidget {
  ProjectSelector({Key key}) : super(key: key);

  @override
  _ProjectSelectorState createState() => _ProjectSelectorState();
}

class _ProjectSelectorState extends State<ProjectSelector> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProjectViewModel>(
      builder: (_, viewModel) => content(viewModel),
      converter: (store) => ProjectViewModel.fromStore(store),
    );
  }

  Widget content(ProjectViewModel viewModel) {
    print('UPDATE Login ${viewModel.session}');

    if (viewModel.session != null) {
      return Container(
        child: Column(
          children: [
            Text(
                'You are already logged in - Expires: ${viewModel.session.expires}'),
            // Center(
            //   child: RaisedButton(
            //     child: Text('Logout'),
            //     onPressed: () => viewModel.getOrganizations(),
            //   ),
            // ),
          ],
        ),
      );
    }

    String selectedOrganization = null;
    String selectedProject = null;

    return Container(
      child: Column(
        children: [
          Center(
              child: DropdownButton<String>(
            value: 'One',
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                selectedOrganization = newValue;
              });
            },
            // Get from APIs
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ))
        ],
      ),
    );
  }
}

class ProjectViewModel {
  ProjectViewModel({this.session, this.getOrganizations});

  final Cookie session;
  final Function(Cookie session) getOrganizations;

  static ProjectViewModel fromStore(Store<AppState> store) => ProjectViewModel(
      session: store.state.globalState.session,
      getOrganizations: (Cookie session) {
        // store.dispatch(LoginAction(session));
        // store.state.globalState.storage
        //     .write(key: 'session', value: session.toString());
        // print(session);
      });
}
