import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:sentry_mobile/redux/actions.dart';
import 'package:sentry_mobile/redux/state/app_state.dart';

void apiMiddleware(Store<AppState> store, dynamic action, NextDispatcher next) async {
  if (action is FetchOrganizationsAction) {
    print('laskdhjflkasjdflhasd');
    final cookie = store.state.globalState.session.toString();
    final client = Client();
    final response = await client.get(
        'https://sentry.io/api/0/organizations/?member=1',
        headers: {'Cookie': cookie});

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body) as List;
      store.dispatch(FetchOrganizationsSuccessAction(responseJson));
    } else {

    }

//    // Use the api to fetch the todos
//    api.fetchTodos().then((List<Todo> todos) {
//      // If it succeeds, dispatch a success action with the todos.
//      // Our reducer will then update the State using these todos.
//      store.dispatch(new FetchTodosSucceededAction(todos));
//    }).catchError((Exception error) {
//      // If it fails, dispatch a failure action. The reducer will
//      // update the state with the error.
//      store.dispatch(new FetchTodosFailedAction(error));
//    });
  }


  next(action);
}