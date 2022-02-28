import 'package:shared_preferences/shared_preferences.dart';
import 'package:strava_flutter/domain/model/model_authentication_response.dart';

import '/models/athlete.dart' as encrateia;

Future<void> persist({required encrateia.Athlete athlete}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  athlete
    ..stravaAccessToken = prefs.getString('strava_accessToken')
    ..stravaExpiresAt = prefs.getInt('strava_expires_at')
    ..stravaExpiresIn = prefs.getInt('strava_expires_in')
    ..stravaTokenType = prefs.getString('strava_token_type')
    ..stravaRefreshToken = prefs.getString('strava_refreshToken');

  await athlete.save();
}

Future<void> load({required encrateia.Athlete athlete}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('strava_accessToken', athlete.stravaAccessToken!);
  await prefs.setInt('strava_expires_at', athlete.stravaExpiresAt!);
  await prefs.setInt('strava_expires_in', athlete.stravaExpiresIn!);
  await prefs.setString('strava_token_type', athlete.stravaTokenType!);
  await prefs.setString('strava_refreshToken', athlete.stravaRefreshToken!);

  // FIXME: We don't use the Response yet!
  TokenResponse(
      tokenType: athlete.stravaTokenType!,
      expiresAt: athlete.stravaExpiresAt!,
      expiresIn: athlete.stravaExpiresIn!,
      accessToken: athlete.stravaAccessToken!,
      refreshToken: athlete.stravaRefreshToken!);
}

Future<void> delete({required encrateia.Athlete athlete}) async {
  athlete
    ..stravaAccessToken = "null"
    ..stravaExpiresAt = 0
    ..stravaExpiresIn = 0
    ..stravaTokenType = "null"
    ..stravaRefreshToken = "null";
  await athlete.save();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('strava_accessToken', "null");
  await prefs.setInt('strava_expires_in', 0);
  await prefs.setInt('strava_expires_at', 0);
  await prefs.setString('strava_token_type', "null");
  await prefs.setString('strava_refreshToken', "null");
}
