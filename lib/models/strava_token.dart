import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/globals.dart' as globals;

import 'athlete.dart';

Future<void> persist({Athlete athlete}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  athlete
    ..stravaAccessToken = prefs.getString('strava_accessToken')
    ..stravaExpire = prefs.getInt('strava_expire')
    ..stravaScope = prefs.getString('strava_scope')
    ..stravaRefreshToken = prefs.getString('strava_refreshToken');

  await athlete.save();
}

Future<void> load({Athlete athlete}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('strava_accessToken', athlete.stravaAccessToken);
  await prefs.setInt('strava_expire', athlete.stravaExpire);
  await prefs.setString('strava_scope', athlete.stravaScope);
  await prefs.setString('strava_refreshToken', athlete.stravaRefreshToken);

  globals.token
    ..accessToken = athlete.stravaAccessToken
    ..scope = athlete.stravaScope
    ..expiresAt = athlete.stravaExpire
    ..refreshToken = athlete.stravaRefreshToken;
}

Future<void> delete({Athlete athlete}) async {
  athlete
    ..stravaAccessToken = null
    ..stravaExpire = null
    ..stravaScope = null
    ..stravaRefreshToken = null;
  await athlete.save();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('strava_accessToken', null);
  await prefs.setInt('strava_expire', null);
  await prefs.setString('strava_scope', null);
  await prefs.setString('strava_refreshToken', null);
}
