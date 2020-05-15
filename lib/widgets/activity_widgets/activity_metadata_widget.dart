import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityMetadataWidget extends StatelessWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityMetadataWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  Widget build(context) {
    return ListTileTheme(
      iconColor: Colors.deepOrange,
      child: GridView.count(
        padding: EdgeInsets.all(5),
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
        childAspectRatio: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        children: [
          ListTile(
              leading: MyIcon.title,
              title: Text(activity.db.name),
              subtitle: Text("title")),
          ListTile(
            leading: MyIcon.timeStamp,
            title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
                .format(activity.db.timeStamp)),
            subtitle: Text('timestamp'),
          ),
          ListTile(
            leading: MyIcon.event,
            title: Text(activity.db.event),
            subtitle: Text('last event'),
          ),
          if (activity.db.totalStrides != null)
            ListTile(
              leading: MyIcon.strides,
              title: Text(activity.db.totalStrides.toString()),
              subtitle: Text('total strides'),
            ),
          if (activity.db.maxRunningCadence != null)
            ListTile(
              leading: MyIcon.cadence,
              title: Text("${activity.db.avgRunningCadence.round()} /"
                  " ${activity.db.maxRunningCadence}"),
              subtitle: Text('avg / max running cadence'),
            ),
          ListTile(
            leading: MyIcon.temperature,
            title: Text(
                '${activity.db.avgTemperature}° / ${activity.db.maxTemperature}°'),
            subtitle: Text('avg / max temperature'),
          ),
          ListTile(
            leading: MyIcon.verticalOscillation,
            title: Text(activity.db.avgVerticalOscillation.toStringAsFixed(2)),
            subtitle: Text('avg vertical oscillation'),
          ),
          ListTile(
            leading: MyIcon.cycles,
            title: Text(activity.db.totalFractionalCycles.toStringAsFixed(2)),
            subtitle: Text('total fractional cycles'),
          ),
          ListTile(
            leading: MyIcon.time,
            title: Text(
                Duration(seconds: activity.db.totalElapsedTime).asString()),
            subtitle: Text('total elapsed time'),
          ),
          ListTile(
            leading: MyIcon.time,
            title:
                Text(Duration(seconds: activity.db.totalTimerTime).asString()),
            subtitle: Text('total timer time'),
          ),
          ListTile(
            leading: MyIcon.id,
            title:
                Text("${activity.db.stravaId} / ${activity.db.serialNumber}"),
            subtitle: Text("Strava / Garmin id"),
          ),
          ListTile(
            leading: MyIcon.sport,
            title: Text(activity.db.type +
                " / " +
                activity.db.sport +
                " / " +
                activity.db.subSport),
            subtitle: Text('activity type / sport / sub sport'),
          ),
          ListTile(
            leading: MyIcon.event,
            title: Text(activity.db.eventType + " / " + activity.db.trigger),
            subtitle: Text('event type / trigger'),
          ),
          ListTile(
            leading: MyIcon.repeats,
            title: Text("${activity.db.numLaps} / ${activity.db.numSessions}"),
            subtitle: Text('number of laps / sessions'),
          ),
          ListTile(
            leading: MyIcon.cadence,
            title: Text(activity.db.avgFractionalCadence.toStringAsFixed(2) +
                " / " +
                activity.db.maxFractionalCadence.toStringAsFixed(2)),
            subtitle: Text('avg / max fractional cadence'),
          ),
          ListTile(
            leading: MyIcon.time,
            title: Text(
                '${activity.db.avgStanceTime} ms / ${activity.db.avgStanceTimePercent} %'),
            subtitle: Text('avg stance time / avg stance time percent'),
          ),
          ListTile(
            leading: MyIcon.position,
            title: Text(activity.db.startPositionLong.semicirclesAsDegrees() +
                " E\n" +
                activity.db.startPositionLat.semicirclesAsDegrees() +
                " N"),
            subtitle: Text('start position'),
          ),
          ListTile(
            leading: MyIcon.position,
            title: Text(activity.db.necLong.semicirclesAsDegrees() +
                " E\n" +
                activity.db.necLat.semicirclesAsDegrees() +
                " N"),
            subtitle: Text('north east corner'),
          ),
          ListTile(
            leading: MyIcon.position,
            title: Text(activity.db.swcLong.semicirclesAsDegrees() +
                " E\n" +
                activity.db.swcLat.semicirclesAsDegrees() +
                " N"),
            subtitle: Text('south west corner'),
          ),
          ListTile(
            leading: MyIcon.speed,
            title: Text((activity.db.avgSpeed * 3.6).toStringAsFixed(2) +
                " km/h / " +
                (activity.db.maxSpeed * 3.6).toStringAsFixed(2) +
                " km/h"),
            subtitle: Text('avg / max speed'),
          ),
        ],
      ),
    );
  }
}
