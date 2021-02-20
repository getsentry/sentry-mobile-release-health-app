import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;

import '../api/api_errors.dart';
import '../types/cursor.dart';
import '../types/group.dart';
import '../types/organization.dart';
import '../types/project.dart';
import '../types/release.dart';
import '../types/sessions.dart';
import '../types/user.dart';
import '../utils/date_time_format.dart';

class SentryApi {
  SentryApi(this.authToken);

  final String authToken;

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

  Future<Organization> organization(String organizationSlug) async {
    final response = await client.get('${_baseUrl()}/organizations/$organizationSlug/',
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Organization.fromJson(jsonMap)).asFuture;
  }

  Future<List<Project>> projects(String slug, Cursor cursor) async {
    final queryParameters = <String, String>{
    };

    if (cursor != null) {
      queryParameters[cursor.queryKey()] = cursor.queryValue();
    }

    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$slug/projects/', queryParameters),
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
    final bodyParameters = <String, String>{
      'isBookmarked': bookmark ? 'true' : 'false',
    };

    final response = await client.put('${_baseUrl()}/projects/$organizationSlug/$projectSlug/',
        headers: _defaultHeader(),
        body: json.encode(bodyParameters)
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

  Future<double> apdex({@required int apdexThreshold, @required String organizationSlug, @required String projectId, @required DateTime start, @required DateTime end}) async {
    final queryParameters = {
      'field': 'apdex($apdexThreshold)',
      'project': projectId,
      'query': 'event.type:transaction count():>0',
      'start': start.utcDateTime(),
      'end': end.utcDateTime(),
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/eventsv2/', queryParameters),
        headers: _defaultHeader()
    );
    if (response.statusCode == 200) {
      try {
        final responseJson = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final data = responseJson['data'] as List<dynamic>;
        if (data.isNotEmpty) {
          final apdexData = data.first as Map<String, dynamic>;
          final apDex = apdexData['apdex_$apdexThreshold'] as double;
          return Result.value(apDex).asFuture;
        } else {
          return Result.value(null).asFuture;
        }
      } catch (e) {
        throw JsonError(e);
      }
    } else {
      throw ApiError(response.statusCode, response.body);
    }
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
    @required Iterable<String> fields,
    String statsPeriod = '24h',
    String interval = '1h',
    String groupBy,
    String statsPeriodStart,
    String statsPeriodEnd}) async {
    final queryParameters = <String, dynamic>{ /*String|Iterable<String>*/
      'project': projectId,
      'interval': interval,
      'field': fields
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

    final request = Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/sessions/')
        .resolveUri(Uri(queryParameters: queryParameters));

    final response = await client.get(request,
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
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
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
