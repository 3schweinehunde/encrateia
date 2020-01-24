import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:html/parser.dart' show parse;

abstract class StravaFitDownload {
  static String baseUri = "https://www.strava.com/";
  static String loginUri = baseUri + "login";
  static String sessionUri = baseUri + "session";
  static String dashboardUri = baseUri + "dashboard";
  static Map<String, String> headers = {
    Headers.acceptHeader:
        "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
  };

  static Future<int> byId({String id, Athlete athlete}) async {
    String exportUri = baseUri + 'activities/$id/export_original';
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    var loggedIn = await logInIfNecessary(dio: dio, athlete: athlete);

    if (loggedIn == true) {
      print("Starting download for $exportUri");
      var downloadResponse =
          await dio.download(exportUri, appDocDir.path + '/$id.fit');
      print("Download fit file for activity $id completed.");

      return downloadResponse.statusCode;
    } else {
      return 401;
    }
  }

  static Future<bool> logInIfNecessary({Dio dio, Athlete athlete}) async {
    var dashboardResponse = await getDashboard(dio: dio);
    if (dashboardResponse.data.toString().contains("logged-in")) {
      print("Already logged in to Strava");
      return true;
    }

    await login(dio: dio, athlete: athlete);

    dashboardResponse = await getDashboard(dio: dio);
    if (dashboardResponse.data.toString().contains("logged-in")) {
      print("Successfully logged in to Strava");
      return true;
    } else {
      print("Error: Could not log in to Strava");
      return false;
    }
  }

  static Future<Response> getDashboard({Dio dio}) async {
    return await dio.get(
      dashboardUri,
      options: Options(headers: headers, validateStatus: (_) => true),
    );
  }

  static Future<void> login({Dio dio, Athlete athlete}) async {
    var homePageResponse = await dio.get(
      loginUri,
      options: Options(headers: headers),
    );

    var document = parse(homePageResponse.data);
    var csrfParam =
        document.querySelector('meta[name="csrf-param"]').attributes["content"];
    var csrfToken =
        document.querySelector('meta[name="csrf-token"]').attributes["content"];

    await dio.post(
      sessionUri,
      options: Options(headers: headers, validateStatus: (_) => true),
      data: {
        "email": athlete.email,
        "password": athlete.password,
        "remember_me": "on",
        csrfParam: csrfToken,
      },
    );
  }
}
