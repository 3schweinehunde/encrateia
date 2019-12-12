import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:html/parser.dart' show parse;
import 'package:encrateia/utils/globals.dart' as globals;

abstract class FitDownload {
  static Future<int> byId({String id, Athlete athlete}) async {
    String baseUri = "https://www.strava.com/";
    String loginUri = baseUri + "login";
    String sessionUri = baseUri + "session";
    String dashboardUri = baseUri + "dashboard";
    String exportUri = baseUri + 'activities/$id/export_original';
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    Map<String, String> headers = {
      Headers.acceptHeader:
          "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    };

    print("Logged in: ${globals.loggedInToStravaWeb}");

    if (globals.loggedInToStravaWeb == false) {
      var homePageResponse = await dio.get(
        loginUri,
        options: Options(headers: headers),
      );
      var document = parse(homePageResponse.data);
      var csrfParam =
      document
          .querySelector('meta[name="csrf-param"]')
          .attributes["content"];
      var csrfToken =
      document
          .querySelector('meta[name="csrf-token"]')
          .attributes["content"];

      Map<String, String> postData = {
        "email": athlete.email,
        "password": athlete.password,
        "remember_me": "on",
        csrfParam: csrfToken,
      };

      await dio.post(
        sessionUri,
        options: Options(
            headers: headers, validateStatus: (int status) => true),
        data: postData,
      );

      await dio.get(
        dashboardUri,
        options: Options(
            headers: headers, validateStatus: (int status) => true),
      );
      globals.loggedInToStravaWeb = true;
    }

    print("Started Download for $exportUri");
    var downloadResponse =
        await dio.download(exportUri, appDocDir.path + '/$id.fit');

    print("Downloaded fit file for activity $id.");
    return downloadResponse.statusCode;
  }
}
