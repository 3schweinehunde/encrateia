import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';

class LapOverviewWidget extends StatelessWidget {
  final Lap lap;

  LapOverviewWidget({this.lap});

  @override
  Widget build(context) {
    return new ListTileTheme(
      iconColor: Colors.lightGreen,
      child: ListView(
        padding: EdgeInsets.only(left: 25),
        children: <Widget>[
          ListTile(
            leading: MyIcon.timeStamp,
            title: Text(
                DateFormat("dd MMM yyyy, h:mm:ss").format(lap.db.startTime)),
            subtitle: Text('start time'),
          ),
          ListTile(
            leading: MyIcon.distance,
            title:
                Text('${(lap.db.totalDistance / 1000).toStringAsFixed(2)} km'),
            subtitle: Text('distance'),
          ),
          ListTile(
            leading: MyIcon.speed,
            title: Text(lap.db.avgSpeed.toPace() + " / " + lap.db.maxSpeed.toPace()),
            subtitle: Text('avg / max pace'),
          ),
          ListTile(
            leading: MyIcon.calories,
            title: Text('${lap.db.totalCalories} kcal'),
            subtitle: Text('total calories'),
          ),
          ListTile(
            leading: MyIcon.climb,
            title: Text("${lap.db.totalAscent} m - ${lap.db.totalDescent} m"
                " = ${lap.db.totalAscent - lap.db.totalDescent} m"),
            subtitle: Text('total ascent - descent = total climb'),
          ),
          ListTile(
            leading: MyIcon.heartRate,
            title:
                Text("${lap.db.avgHeartRate} bpm / ${lap.db.maxHeartRate} bpm"),
            subtitle: Text('avg / max heart rate'),
          ),
          ListTile(
            leading: MyIcon.cadence,
            title: Text("${(lap.db.avgRunningCadence ?? 0 * 2).round()} spm / "
                "${lap.db.maxRunningCadence ?? 0 * 2} spm"),
            subtitle: Text('avg / max steps per minute'),
          ),
          ListTile(
            leading: MyIcon.strides,
            title: Text(lap.db.totalStrides.toString()),
            subtitle: Text('total strides'),
          ),
        ],
      ),
    );
  }
}
