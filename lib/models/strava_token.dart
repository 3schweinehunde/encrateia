import 'package:strava_flutter/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'athlete.dart';

class StravaToken {
  static Future<void> persistTokenData({Athlete athlete}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    athlete
      ..stravaAccessToken = prefs.getString('strava_accessToken')
      ..stravaExpire = prefs.getInt('strava_expire')
      ..stravaScope = prefs.getString('strava_scope')
      ..stravaRefreshToken = prefs.getString('strava_refreshToken');

    await athlete.save();
  }

  static Future<void> loadTokenData({Athlete athlete}) async {
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
}
