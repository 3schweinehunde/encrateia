import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';

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
            leading: Icon(Icons.access_time),
            title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
                .format(activity.db.timeCreated)),
            subtitle: Text('time created'),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text(Duration(seconds: activity.db.movingTime).print()),
            subtitle: Text('moving time'),
          ),
          ListTile(
            leading: Icon(Icons.redo),
            title:
                Text('${(activity.db.distance / 1000).toStringAsFixed(2)} km'),
            subtitle: Text('distance'),
          ),
          ListTile(
            leading: Icon(Icons.shutter_speed),
            title: Text(activity.db.avgSpeed.toPace() +
                " / " +
                activity.db.maxSpeed.toPace()),
            subtitle: Text('avg / max pace'),
          ),
          ListTile(
            leading: Icon(Icons.battery_charging_full),
            title: Text('${activity.db.totalCalories} kcal'),
            subtitle: Text('total calories'),
          ),
          ListTile(
            leading: Icon(Icons.landscape),
            title: Text(
                "${activity.db.totalAscent} m - ${activity.db.totalDescent} m"
                " = ${activity.db.totalAscent - activity.db.totalDescent} m"),
            subtitle: Text('total ascent - descent = total climb'),
          ),
          ListTile(
            leading: Icon(Icons.spa),
            title: Text(
                "${activity.db.avgHeartRate} bpm / ${activity.db.maxHeartRate} bpm"),
            subtitle: Text('avg / max heart rate'),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text("${(activity.db.avgRunningCadence ?? 0 * 2).round()} spm / "
                "${activity.db.maxRunningCadence ?? 0 * 2} spm"),
            subtitle: Text('avg / max steps per minute'),
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text(activity.db.totalTrainingEffect.toString()),
            subtitle: Text('total training effect'),
          ),
        ],
      ),
    );
  }
}
