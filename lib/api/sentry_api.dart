import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;

import '../api/api_errors.dart';
import '../types/group.dart';
import '../types/organization.dart';
import '../types/project.dart';
import '../types/release.dart';
import '../types/sessions.dart';
import '../types/user.dart';

class SentryApi {
  SentryApi(this.session, this.sc);

  final Cookie session;
  final Cookie sc;

  final client = sentry.SentryHttpClient(client: Client());
  final baseUrlScheme = 'https://';
  final baseUrlName = 'sentry.io';
  final baseUrlPath = '/api/0';

  Future<List<Organization>> organizations() async {
    final response = await client.get('${_baseUrl()}/organizations/?member=1',
        headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Organization.fromJson(jsonMap)).asFuture;
  }

  Future<List<Project>> projects(String slug) async {
    final response = await client.get('${_baseUrl()}/organizations/$slug/projects/',
        headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Project.fromJson(jsonMap)).asFuture;
  }

  Future<Project> project(String organizationSlug, String projectSlug) async {
    final response = await client.get('${_baseUrl()}/projects/$organizationSlug/$projectSlug/',
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Project.fromJson(jsonMap)).asFuture;
  }

  Future<Project> bookmarkProject(String organizationSlug, String projectSlug, bool bookmark) async {
    final queryParameters = <String, String>{
      'isBookmarked': bookmark ? 'true' : 'false',
    };
    final response = await client.put(Uri.https(baseUrlName, '${_baseUrl()}/projects/$organizationSlug/$projectSlug/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Project.fromJson(jsonMap)).asFuture;
  }

  Future<List<Release>> releases({@required String organizationSlug, @required String projectId, int perPage = 25, int health = 1, int flatten = 0, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'project': projectId,
      'perPage': '$perPage',
      'health': '$health',
      'flatten': '$flatten',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/releases/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Release.fromJson(jsonMap)).asFuture;
  }

  Future<Release> release({@required String organizationSlug, @required String projectId, @required String releaseId, int health = 1, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'project': projectId,
      'health': '$health',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/releases/$releaseId/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Release.fromJson(jsonMap)).asFuture;
  }

  Future<List<Group>> issues({@required String organizationSlug, @required String projectSlug}) async {
    final queryParameters = {
      'statsPeriod': '24h'
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/projects/$organizationSlug/$projectSlug/issues/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Group.fromJson(jsonMap)).asFuture;
  }

  Future<User> authenticatedUser() async {
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/'),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => User.fromJson(jsonMap['user'] as Map<String, dynamic>)).asFuture;
  }

  Future<Sessions> sessions({
    @required String organizationSlug,
    @required String projectId,
    @required String field,
    String statsPeriod = '12h',
    String interval = '1h',
    String groupBy,
    String statsPeriodStart,
    String statsPeriodEnd}) async {
    final queryParameters = <String, String>{
      'project': projectId,
      'interval': interval,
      'field': field
    };
    if (groupBy != null) {
      queryParameters['groupBy'] = groupBy;
    }
    if (statsPeriodStart != null && statsPeriodEnd != null) {
      queryParameters['statsPeriodStart'] = statsPeriodStart;
      queryParameters['statsPeriodEnd'] = statsPeriodEnd;
    } else {
      queryParameters['statsPeriod'] = statsPeriod;
    }
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/sessions/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Sessions.fromJson(jsonMap)).asFuture;
  }

  void close() {
    client.close();
  }

  // Helper

  String _baseUrl() {
    return '$baseUrlScheme$baseUrlName$baseUrlPath';
  }

  Map<String, String> _defaultHeader() {
    final headerFields = <String, String>{};
    var cookie = 'session=${session.value};';
    if (sc != null) {
      cookie += ' sc=${sc.value};';
      headerFields['X-CSRFToken'] = sc.value;
    }
    headerFields['Cookie'] = cookie;
    return headerFields;
  }

  Result<List<T>> _parseResponseList<T>(Response response, T Function(Map<String, dynamic> r) map) {
    if (response.statusCode == 200) {
      try {
        final responseJson = json.decode(utf8.decode(response.bodyBytes)) as List;
        final orgList = List<Map<String, dynamic>>.from(responseJson);
        return Result.value(orgList.map((Map<String, dynamic> r) => map(r)).toList());
      } catch (e) {
        return Result.error(JsonError(e));
      }
    } else {
      return Result.error(ApiError(response.statusCode, response.body));
    }
  }

  Result<T> _parseResponse<T>(Response response, T Function(Map<String, dynamic> r) map) {
    if (response.statusCode == 200) {
      try {
        final responseJson = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return Result.value(map(responseJson));
      } catch (e) {
        return Result.error(JsonError(e));
      }
    } else {
      return Result.error(ApiError(response.statusCode, response.body));
    }
  }
}
