import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';

class ActivityMetadataWidget extends StatelessWidget {
  final Activity activity;

  ActivityMetadataWidget({this.activity});

  @override
  Widget build(context) {
    return new ListTileTheme(
      iconColor: Colors.deepOrange,
      child: ListView(
        padding: EdgeInsets.only(left: 25),
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.title),
              title: Text(activity.db.name),
              subtitle: Text("title")),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
                .format(activity.db.timeStamp)),
            subtitle: Text('timestamp'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(activity.db.event),
            subtitle: Text('last event'),
          ),
          if (activity.db.totalStrides != null)
            ListTile(
              leading: Icon(Icons.directions_walk),
              title: Text(activity.db.totalStrides.toString()),
              subtitle: Text('total strides'),
            ),
          if (activity.db.maxRunningCadence != null)
            ListTile(
              leading: Icon(Icons.pets),
              title: Text("${activity.db.avgRunningCadence.round()} /"
                  " ${activity.db.maxRunningCadence}"),
              subtitle: Text('avg / max running cadence'),
            ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text(
                '${activity.db.avgTemperature}° / ${activity.db.maxTemperature}°'),
            subtitle: Text('avg / max temperature'),
          ),
          ListTile(
            leading: Icon(Icons.unfold_more),
            title: Text(activity.db.avgVerticalOscillation.toString()),
            subtitle: Text('avg vertical oscillation'),
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text(activity.db.totalFractionalCycles.toString()),
            subtitle: Text('total fractional cycles'),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title:
                Text(Duration(seconds: activity.db.totalElapsedTime).print()),
            subtitle: Text('total elapsed time'),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text(Duration(seconds: activity.db.totalTimerTime).print()),
            subtitle: Text('total timer time'),
          ),
          ListTile(
            leading: Icon(Icons.fingerprint),
            title:
                Text("${activity.db.stravaId} / ${activity.db.serialNumber}"),
            subtitle: Text("Strava / Garmin id"),
          ),
          ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text(activity.db.type +
                " / " +
                activity.db.sport +
                " / " +
                activity.db.subSport),
            subtitle: Text('activity type / sport / sub sport'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(activity.db.eventType + " / " + activity.db.trigger),
            subtitle: Text('event type / trigger'),
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text("${activity.db.numLaps} / ${activity.db.numSessions}"),
            subtitle: Text('number of laps / sessions'),
          ),
          ListTile(
            leading: Icon(Icons.linear_scale),
            title: Text(activity.db.avgFractionalCadence.toStringAsFixed(2) +
                " / " +
                activity.db.maxFractionalCadence.toStringAsFixed(2)),
            subtitle: Text('avg / max fractional cadence'),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text(
                '${activity.db.avgStanceTime} ms / ${activity.db.avgStanceTimePercent} %'),
            subtitle: Text('avg stance time / avg stance time percent'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(activity.db.startPositionLong.semicirclesAsDegrees() +
                "   /   " +
                activity.db.startPositionLat.semicirclesAsDegrees()),
            subtitle: Text('start position'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(activity.db.necLong.semicirclesAsDegrees() +
                "   /   " +
                activity.db.necLat.semicirclesAsDegrees()),
            subtitle: Text('north east corner'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(activity.db.swcLong.semicirclesAsDegrees() +
                "   /   " +
                activity.db.swcLat.semicirclesAsDegrees()),
            subtitle: Text('south west corner'),
          ),
        ],
      ),
    );
  }
}
