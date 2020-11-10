import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:async/async.dart';

import 'package:sentry_mobile/types/organization.dart';
import 'package:sentry_mobile/types/project.dart';
import 'package:sentry_mobile/types/release.dart';
import 'package:sentry_mobile/api/api_errors.dart';

class SentryApi {
  SentryApi(this.session);

  final Cookie session;
  final client = Client();
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

  Future<List<Release>> releases(String projectId, {int perPage = 25, int health = 1, int flatten = 0, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'perPage': '$perPage',
      'health': '$health',
      'flatten': '$flatten',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$projectId/releases/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponseList(response, (jsonMap) => Release.fromJson(jsonMap)).asFuture;
  }

  Future<Release> release(String projectId, String releaseId, {int health = 1, String summaryStatsPeriod = '24h'}) async {
    final queryParameters = {
      'health': '$health',
      'summaryStatsPeriod': summaryStatsPeriod,
    };
    final response = await client.get(Uri.https(baseUrlName, '$baseUrlPath/organizations/$projectId/releases/$releaseId/', queryParameters),
        headers: _defaultHeader()
    );
    return _parseResponse(response, (jsonMap) => Release.fromJson(jsonMap)).asFuture;
  }

  void close() {
    client.close();
  }

  // Helper

  String _baseUrl() {
    return '$baseUrlScheme$baseUrlName$baseUrlPath';
  }

  Map<String, String> _defaultHeader() {
    return {'Cookie': session.toString()};
  }

  Result<List<T>> _parseResponseList<T>(Response response, T Function(Map<String, dynamic> r) map) {
    if (response.statusCode == 200) {
      try {
        final responseJson = json.decode(response.body) as List;
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
        final responseJson = json.decode(response.body) as Map<String, dynamic>;
        return Result.value(map(responseJson));
      } catch (e) {
        return Result.error(JsonError(e));
      }
    } else {
      return Result.error(ApiError(response.statusCode, response.body));
    }
  }
}
