import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';

class ShowActivityScreen extends StatelessWidget {
  final Activity activity;

  const ShowActivityScreen({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${activity.db.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.title),
            title: Text(activity.db.name),
          ),
          ListTile(
            leading: Icon(Icons.fingerprint),
            title: Text(activity.db.stravaId.toString()),
            subtitle: Text(activity.db.serialNumber.toString()),
            trailing: Text("Strava id \nGarmin id"),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text(Duration(seconds: activity.db.movingTime).print()),
            trailing: Text('moving time (hh:mm:ss)'),
          ),
          ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text(activity.db.type),
            subtitle: Text(activity.db.sport + '/' + activity.db.subSport),
            trailing: Text('activity type \nsport / sub sport'),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(DateFormat("dd MMM yyyy  hh:mm:ss")
                .format(activity.db.timeCreated)),
            trailing: Text('time created'),
          ),
          ListTile(
            leading: Icon(Icons.redo),
            title:
                Text('${(activity.db.distance / 1000).toStringAsFixed(2)} km'),
            trailing: Text('distance'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(activity.db.event + " / " + activity.db.eventType),
            trailing: Text('last event / event type'),
          ),
          ListTile(
            leading: Icon(Icons.battery_charging_full),
            title: Text('${activity.db.totalCalories} kcal'),
            trailing: Text('total calories'),
          ),
          if (activity.db.totalStrides != null)  ListTile(
            leading: Icon(Icons.directions_walk),
            title: Text(activity.db.totalStrides.toString()),
            trailing: Text('total strides'),
          ),
          ListTile(
            leading: Icon(Icons.shutter_speed),
            title:
                Text((activity.db.avgSpeed * 3.6).toStringAsFixed(2) + " km/h"),
            trailing: Text('average speed'),
          ),
          ListTile(
            leading: Icon(Icons.airplanemode_active),
            title:
                Text((activity.db.maxSpeed * 3.6).toStringAsFixed(2) + " km/h"),
            trailing: Text('maximum speed'),
          ),
          ListTile(
            leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Icon(Icons.trending_up),
              Icon(Icons.landscape),
            ]),
            title: Text("${activity.db.totalAscent} m"),
            trailing: Text('total ascent'),
          ),
          ListTile(
            leading: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Icon(Icons.trending_down),
              Icon(Icons.landscape),
            ]),
            title: Text("${activity.db.totalDescent} m"),
            trailing: Text('total descent'),
          ),
          if (activity.db.maxRunningCadence != null) ListTile(
            leading: Icon(Icons.directions_run),
            title: Text(activity.db.maxRunningCadence.toString()),
            trailing: Text('maximum running cadence'),
          ),
        ],
      ),
    );
  }

//double startPositionLat;
//double startPositionLong;
//String trigger;
//int avgTemperature;
//int maxTemperature;
//double avgFractionalCadence;
//double maxFractionalCadence;
//double totalFractionalCycles;
//double avgStanceTimePercent;
//double avgStanceTime;
//int avgHeartRate;
//int maxHeartRate;
//double avgRunningCadence;
//double avgVerticalOscillation;
//int totalElapsedTime;
//int totalTimerTime;
//int totalTrainingEffect;
//double necLat;
//double necLong;
//double swcLat;
//double swcLong;
//int firstLapIndex;
//int numLaps;
//int numSessions;
//DateTime localTimestamp;
//int athletesId;
}
