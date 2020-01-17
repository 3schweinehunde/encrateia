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
            subtitle: Text(
                Duration(seconds: activity.db.totalElapsedTime).print() +
                    "\n" +
                    Duration(seconds: activity.db.totalTimerTime).print()),
            trailing: Text(
                'moving time (hh:mm:ss)\ntotal elapsed time\ntotal timer time'),
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
          if (activity.db.totalStrides != null)
            ListTile(
              leading: Icon(Icons.directions_walk),
              title: Text(activity.db.totalStrides.toString()),
              trailing: Text('total strides'),
            ),
          ListTile(
            leading: Icon(Icons.shutter_speed),
            title:
                Text((activity.db.avgSpeed * 3.6).toStringAsFixed(2) + " km/h"),
            trailing: Text('avg speed'),
          ),
          ListTile(
            leading: Icon(Icons.airplanemode_active),
            title:
                Text((activity.db.maxSpeed * 3.6).toStringAsFixed(2) + " km/h"),
            trailing: Text('max speed'),
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
          if (activity.db.maxRunningCadence != null)
            ListTile(
              leading: Icon(Icons.directions_run),
              title: Text(activity.db.maxRunningCadence.toString()),
              trailing: Text('max running cadence'),
            ),
          ListTile(
            leading: Icon(Icons.settings_input_antenna),
            title: Text(activity.db.trigger),
            trailing: Text('trigger'),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title: Text(
                '${activity.db.avgTemperature}°... ${activity.db.maxTemperature}°'),
            trailing: Text('avg ... max temperature'),
          ),
          ListTile(
            leading: Icon(Icons.linear_scale),
            title: Text(
                '${activity.db.avgFractionalCadence.toStringAsFixed(2)}... ${activity.db.maxFractionalCadence.toStringAsFixed(2)}'),
            trailing: Text('avg ... max\nfractional cadence'),
          ),
          ListTile(
            leading: Icon(Icons.spa),
            title: Text(
                '${activity.db.avgHeartRate}... ${activity.db.maxHeartRate}'),
            trailing: Text('avg ... max heart rate'),
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text('${activity.db.numLaps} / ${activity.db.numSessions}'),
            trailing: Text('number of laps / sessions'),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text(
                '${activity.db.avgStanceTime}ms / ${activity.db.avgStanceTimePercent}%'),
            trailing: Text('avg stance time / %'),
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text(activity.db.totalTrainingEffect.toString()),
            trailing: Text('total training effect'),
          ),
          ListTile(
            leading: Icon(Icons.unfold_more),
            title: Text(activity.db.avgVerticalOscillation.toString()),
            trailing: Text('avg vertical oscillation'),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text(activity.db.avgRunningCadence.toString()),
            trailing: Text('avg running cadence'),
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text(activity.db.totalFractionalCycles.toString()),
            trailing: Text('total fractional cycles'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(activity.db.startPositionLong.semicirclesAsDegrees() +
                " /\n" +
                activity.db.startPositionLat.semicirclesAsDegrees()),
            trailing: Text('start position long /\nlat'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(activity.db.necLong.semicirclesAsDegrees() +
                " /\n" +
                activity.db.necLat.semicirclesAsDegrees()),
            trailing: Text('north east corner long /\nlat'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(activity.db.swcLong.semicirclesAsDegrees() +
                " /\n" +
                activity.db.swcLat.semicirclesAsDegrees()),
            trailing: Text('south west corner long /\nlat'),
          ),
        ],
      ),
    );
  }
}
