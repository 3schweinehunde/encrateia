import 'package:encrateia/models/fit_download.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/strava.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/Models/activity.dart' as StravaActivity;
import 'package:encrateia/models/athlete.dart';

class Activity extends ChangeNotifier {
  DbActivity db;

  Activity();
  Activity.fromDb(this.db);

  Activity.fromStrava(StravaActivity.SummaryActivity summaryActivity) {
    this.db
      ..name = summaryActivity.name
      ..movingTime = summaryActivity.movingTime
      ..type = summaryActivity.type
      ..distance = summaryActivity.distance.toInt();
  }

  String toString() => '$db.name $db.startTime';

  Duration movingDuration() => Duration(seconds: db.movingTime ?? 0);
  DateTime startDateTime() => DateTime.parse(db.startTime);

  download({@required Athlete athlete}) async {
    int statusCode = await FitDownload.byId(
      id: db.stravaId.toString(),
      athlete: athlete,
    );
    print("Download status code $statusCode.");

    setState("downloaded");
  }

  setState(String state) {
    db
      ..state = state
      ..save();
    notifyListeners();
  }

  static queryStrava() async {
    Strava strava = Strava(true, secret);
    final prompt = 'auto';

    await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final startDate = now - 20 * 86400;

    List<StravaActivity.SummaryActivity> summaryActivities =
        await strava.getLoggedInAthleteActivities(now, startDate);

    for (StravaActivity.SummaryActivity summaryActivity in summaryActivities) {
      Activity.fromStrava(summaryActivity).db.save;
    }
  }

  static Future<List<Activity>> all() async {
    List<DbActivity> dbActivityList = await DbActivity().select().toList();
    return dbActivityList
        .map((dbActivity) => Activity.fromDb(dbActivity))
        .toList();
  }
}
