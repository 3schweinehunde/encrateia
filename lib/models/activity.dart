import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/utils/db.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/Models/activity.dart';

class Activity extends Model {
  int id;
  bool downloaded;
  String path;
  bool parsed;
  int stravaId;

  String name;
  Duration movingTime;
  String type;
  DateTime startDateTime;
  int distance;

  Activity();
  String toString() => '$name $startDateTime';

  updateFromStravaAthlete(Activity activity) {
    stravaId = activity.stravaId;
    // ...
    notifyListeners();
  }

  persist() async {
    await Db.create().connect();

    var dbActivity = DbActivity(
        stravaId: stravaId,
        // ...
        );
    int id = await dbActivity.save();
  }

  static Activity of(BuildContext context) => ScopedModel.of<Activity>(context);
}
