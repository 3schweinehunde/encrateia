import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityOverviewWidget extends StatelessWidget {
  final Activity activity;

  ActivityOverviewWidget({this.activity});

  @override
  Widget build(context) {
    return new ListTileTheme(
      iconColor: Colors.deepOrange,
      child: ListView(
        padding: EdgeInsets.only(left: 25),
        children: <Widget>[
          ListTile(
            leading: MyIcon.timeStamp,
            title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
                .format(activity.db.timeCreated)),
            subtitle: Text('time created'),
          ),
          ListTile(
            leading: MyIcon.time,
            title: Text(Duration(seconds: activity.db.movingTime).asString()),
            subtitle: Text('moving time'),
          ),
          ListTile(
            leading: MyIcon.distance,
            title:
                Text('${(activity.db.distance / 1000).toStringAsFixed(2)} km'),
            subtitle: Text('distance'),
          ),
          ListTile(
            leading: MyIcon.speed,
            title: Text(activity.db.avgSpeed.toPace() +
                " / " +
                activity.db.maxSpeed.toPace()),
            subtitle: Text('avg / max pace'),
          ),
          ListTile(
            leading: MyIcon.calories,
            title: Text('${activity.db.totalCalories} kcal'),
            subtitle: Text('total calories'),
          ),
          ListTile(
            leading: MyIcon.climb,
            title: Text(
                "${activity.db.totalAscent} m - ${activity.db.totalDescent} m"
                " = ${activity.db.totalAscent - activity.db.totalDescent} m"),
            subtitle: Text('total ascent - descent = total climb'),
          ),
          ListTile(
            leading: MyIcon.heartRate,
            title: Text(
                "${activity.db.avgHeartRate} bpm / ${activity.db.maxHeartRate} bpm"),
            subtitle: Text('avg / max heart rate'),
          ),
          ListTile(
            leading: MyIcon.cadence,
            title: Text("${(activity.db.avgRunningCadence ?? 0 * 2).round()} spm / "
                "${activity.db.maxRunningCadence ?? 0 * 2} spm"),
            subtitle: Text('avg / max steps per minute'),
          ),
          ListTile(
            leading: MyIcon.trainingEffect,
            title: Text(activity.db.totalTrainingEffect.toString()),
            subtitle: Text('total training effect'),
          ),
        ],
      ),
    );
  }
}
