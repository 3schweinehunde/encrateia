import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:path_provider/path_provider.dart';

import 'athlete.dart';

// ignore: avoid_classes_with_only_static_members
abstract class StravaFitDownload {
  static String baseUri = 'https://www.strava.com/';
  static String loginUri = baseUri + 'login';
  static String sessionUri = baseUri + 'session';
  static String dashboardUri = baseUri + 'dashboard';
  static Map<String, String> headers = <String, String>{
    Headers.acceptHeader:
        'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
  };

  static Future<int> byId({String id, Athlete athlete}) async {
    final String exportUri = baseUri + 'activities/$id/export_original';
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    final Dio dio = Dio();
    final CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    final bool loggedIn = await logInIfNecessary(dio: dio, athlete: athlete);

    if (loggedIn == true) {
      print('Starting download for $exportUri');
      final Response<dynamic> downloadResponse =
          await dio.download(exportUri, appDocDir.path + '/$id.fit');
      print('Download fit file for activity $id completed.');

      return downloadResponse.statusCode;
    } else {
      return 401;
    }
  }

  static Future<bool> logInIfNecessary(
      {@required Dio dio, @required Athlete athlete}) async {
    Response<dynamic> dashboardResponse = await getDashboard(dio: dio);
    if (dashboardResponse.data.toString().contains('logged-in')) {
      print('Already logged in to Strava');
      return true;
    }

    await login(dio: dio, athlete: athlete);

    dashboardResponse = await getDashboard(dio: dio);
    if (dashboardResponse.data.toString().contains('logged-in')) {
      print('Successfully logged in to Strava');
      return true;
    } else {
      print('Error: Could not log in to Strava');
      return false;
    }
  }

  static Future<Response<dynamic>> getDashboard({Dio dio}) async {
    return await dio.get<dynamic>(
      dashboardUri,
      options: Options(headers: headers, validateStatus: (_) => true),
    );
  }

  static Future<void> login({Dio dio, Athlete athlete}) async {
    final Response<dynamic> homePageResponse = await dio.get<dynamic>(
      loginUri,
      options: Options(headers: headers),
    );

    final Document document = parse(homePageResponse.data);
    final String csrfParam =
        document.querySelector('meta[name="csrf-param"]').attributes['content'];
    final String csrfToken =
        document.querySelector('meta[name="csrf-token"]').attributes['content'];

    await dio.post<dynamic>(
      sessionUri,
      options: Options(headers: headers, validateStatus: (_) => true),
      data: <String, String>{
        'email': athlete.email,
        'password': athlete.password,
        'remember_me': 'on',
        csrfParam: csrfToken,
      },
    );
  }

  static Future<bool> credentialsAreValid({@required Athlete athlete}) async {
    final Dio dio = Dio();
    final CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    await login(dio: dio, athlete: athlete);
    final Response<dynamic> dashboardResponse = await getDashboard(dio: dio);
    return dashboardResponse.data.toString().contains('logged-in');
  }
}
