import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/utils/db.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/strava.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/Models/activity.dart';

class Activity extends Model {
  int id;
  String state;
  String path;
  int stravaId;
  String name;
  Duration movingTime;
  String type;
  DateTime startDateTime;
  int distance;

  Activity();
  String toString() => '$name $startDateTime';

  Activity.fromStrava(SummaryActivity activity)
      : stravaId = activity.id,
        name = activity.name,
        movingTime = Duration(seconds: activity.movingTime),
        type = activity.type,
        distance = activity.distance.toInt();

  persist() async {
    await Db.create().connect();

    var dbActivity = DbActivity(
      stravaId: stravaId,
      name: name,
      movingTime: movingTime.inSeconds,
      type: type,
      distance: distance,
    );
    await dbActivity.save();
  }

  static Activity of(BuildContext context) => ScopedModel.of<Activity>(context);

  static queryStrava() async {
    Strava strava = Strava(true, secret);
    final prompt = 'auto';

    await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);

    final now = DateTime
        .now()
        .millisecondsSinceEpoch ~/ 1000;

    final startDate = now - 2 * 86400;

    List<SummaryActivity> summaryActivities = await strava
        .getLoggedInAthleteActivities(now, startDate);

    for(SummaryActivity summaryActivity in summaryActivities) {
      Activity activity = Activity.fromStrava(summaryActivity);
      activity.persist();
    }

    print("Hello");
  }
}

