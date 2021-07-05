import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:sentry_flutter/sentry_flutter.dart' as sentry;

import '../api/api_errors.dart';
import '../types/group.dart';
import '../types/organization.dart';
import '../types/project.dart';
import '../types/release.dart';
import '../types/session_group.dart';
import '../types/session_group_by.dart';
import '../types/sessions.dart';
import '../types/user.dart';
import '../utils/date_time_format.dart';

class SentryApi {
  SentryApi(this.authToken);

  final String? authToken;

  final client = sentry.SentryHttpClient(
    captureFailedRequests: true,
    sendDefaultPii: false,
    failedRequestStatusCodes: [sentry.SentryStatusCode.range(400, 599)],
  );
  final baseUrlName = 'sentry.io';
  final baseUrlPath = '/api/0';

  Future<List<Organization>> organizations() async {
    final queryParameters = <String, dynamic>{ /*String|Iterable<String>*/
      'member': '1',
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/', queryParameters),
      headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Organization.fromJson(jsonMap));
  }

  Future<Organization> organization(String organizationSlug) async {
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/'),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Organization.fromJson(jsonMap!));
  }

  Future<List<Project>> projects(String? slug) async {
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$slug/projects/'),
        headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Project.fromJson(jsonMap));
  }

  Future<Project> project(String organizationSlug, String projectSlug) async {
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/projects/$organizationSlug/$projectSlug/'),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Project.fromJson(jsonMap!));
  }

  Future<Set<String>>projectIdsWithSessions(String organizationSlug) async {
    final queryParameters = <String, dynamic>{ /*String|Iterable<String>*/
      'project': '-1',
      'interval': '1d',
      'statsPeriod': '90d',
      'field': SessionGroup.sumSessionKey,
      'groupBy': SessionGroupBy.projectKey
    };

    final request = Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/sessions/')
        .resolveUri(Uri(queryParameters: queryParameters));

    final response = await client.get(request,
        headers: _defaultHeader()
    );

    final sessions = _parseResponse(response, (jsonMap) => Sessions.fromJson(jsonMap!));
    final projectIds = <String>{};
    for (final group in sessions.groups!) {
      projectIds.add(group.by!.project.toString());
    }
    return projectIds;
  }

  Future<Project> bookmarkProject(String organizationSlug, String projectSlug, bool bookmark) async {
    final bodyParameters = <String, dynamic>{
      'isBookmarked': bookmark,
    };

    final response = await client.put(Uri.https(baseUrlName, '$baseUrlPath/projects/$organizationSlug/$projectSlug/'),
        headers: _defaultHeader(),
        body: json.encode(bodyParameters)
    );
    return _parseResponse(response, (jsonMap) => Project.fromJson(jsonMap!));
  }

  Future<List<Release>> releases({required String organizationSlug, required String projectId, int perPage = 25, int health = 1, int flatten = 0, String summaryStatsPeriod = '24h'}) async {
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
    return _parseResponseList(response, (jsonMap) => Release.fromJson(jsonMap));
  }

  Future<Release> release({required String organizationSlug, required String? projectId, required String? releaseId, int health = 1, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'project': projectId,
      'health': '$health',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$organizationSlug/releases/$releaseId/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Release.fromJson(jsonMap));
  }

  Future<List<Group>> issues({required String? organizationSlug, required String? projectSlug}) async {
    final queryParameters = {
      'statsPeriod': '24h'
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/projects/$organizationSlug/$projectSlug/issues/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Group.fromJson(jsonMap));
  }

  Future<double?> apdex({required int apdexThreshold, required String organizationSlug, required String projectId, required DateTime start, required DateTime end}) async {
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
      final responseJson = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final data = responseJson['data'] as List<dynamic>;
      if (data.isNotEmpty) {
        final apdexData = data.first as Map<String, dynamic>;
        return apdexData['apdex_$apdexThreshold'] as double;
      } else {
        return null;
      }
    } else {
      throw ApiError(response.statusCode, response.body);
    }
  }

  Future<User> authenticatedUser() async {
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/'),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => User.fromJson(jsonMap!['user'] as Map<String, dynamic>));
  }

  Future<Sessions> sessions({
    required String organizationSlug,
    required String projectId,
    required Iterable<String> fields,
    String statsPeriod = '24h',
    String interval = '1h',
    String? groupBy,
    String? statsPeriodStart,
    String? statsPeriodEnd}) async {
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
    return _parseResponse(response, (jsonMap) => Sessions.fromJson(jsonMap!));
  }

  void close() {
    client.close();
  }

  // Helper

  Map<String, String> _defaultHeader() {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  List<T> _parseResponseList<T>(Response response, T Function(Map<String, dynamic> r) map) {
    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes)) as List;
      final orgList = List<Map<String, dynamic>>.from(responseJson);
      return orgList.map((Map<String, dynamic> r) => map(r)).toList();
    } else {
      throw ApiError(response.statusCode, response.body);
    }
  }

  T _parseResponse<T>(Response response, T Function(Map<String, dynamic>? r) map) {
    if (response.statusCode == 200) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>?;
      return map(responseJson);
    } else {
      throw ApiError(response.statusCode, response.body);
    }
  }
}
