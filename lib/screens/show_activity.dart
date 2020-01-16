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
          'Activity ${activity.db.name}',
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
            title: Text(DateFormat("dd MMM yyyy  hh:mm:ss").format(activity.db.timeCreated)),
            trailing: Text('time created'),
          ),
          ListTile(
            leading: Icon(Icons.redo),
            title: Text('${(activity.db.distance / 1000).toStringAsFixed(2)} km'),
            trailing: Text('distance'),
          ),
        ],
      ),
    );
  }

//double startPositionLat;
//double startPositionLong;
//String event;
//String eventType;
//int eventGroup;
//int totalDistance;
//int totalStrides;
//int totalCalories;
//double avgSpeed;
//double maxSpeed;
//int totalAscent;
//int totalDescent;
//int maxRunningCadence;
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


