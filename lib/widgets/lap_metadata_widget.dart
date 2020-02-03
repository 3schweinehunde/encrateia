import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapMetadataWidget extends StatelessWidget {
  final Lap lap;

  LapMetadataWidget({this.lap});

  @override
  Widget build(context) {
    return new ListTileTheme(
      iconColor: Colors.lightGreen,
      child: ListView(
        padding: EdgeInsets.only(left: 25),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.repeat_one),
            title: Text('Lap ${lap.index}'),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text(
                DateFormat("dd MMM yyyy, h:mm:ss").format(lap.db.timeStamp)),
            subtitle: Text('timestamp'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(lap.db.event),
            subtitle: Text("event"),
          ),
          ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text(lap.db.sport + ' / ' + lap.db.subSport),
            subtitle: Text('sport / sub sport'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title:
                Text(lap.db.eventType + " / " + lap.db.eventGroup.toString()),
            subtitle: Text('event type / group'),
          ),
          ListTile(
            leading: MyIcon.verticalOscillation,
            title: Text(lap.db.avgVerticalOscillation.toString()),
            subtitle: Text('avg vertical oscillation'),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text(Duration(seconds: lap.db.totalElapsedTime).asString()),
            subtitle: Text('total elapsed time'),
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text(Duration(seconds: lap.db.totalTimerTime).asString()),
            subtitle: Text('total timer time'),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text(
                '${lap.db.avgStanceTime} ms / ${lap.db.avgStanceTimePercent} %'),
            subtitle: Text('avg stance time / avg stance time percent'),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(lap.db.lapTrigger),
            subtitle: Text('lap trigger'),
          ),
          ListTile(
            leading: Icon(Icons.ac_unit),
            title:
                Text('${lap.db.avgTemperature}° / ${lap.db.maxTemperature}°'),
            subtitle: Text('avg / max temperature'),
          ),
          ListTile(
            leading: Icon(Icons.linear_scale),
            title: Text(lap.db.avgFractionalCadence.toStringAsFixed(2) +
                " / " +
                lap.db.maxFractionalCadence.toStringAsFixed(2)),
            subtitle: Text('avg / max fractional cadence'),
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text(lap.db.totalFractionalCycles.toString()),
            subtitle: Text('total fractional cycles'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(lap.db.startPositionLong.semicirclesAsDegrees() +
                "   /   " +
                lap.db.startPositionLat.semicirclesAsDegrees()),
            subtitle: Text('start position'),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text(lap.db.endPositionLong.semicirclesAsDegrees() +
                "   /   " +
                lap.db.endPositionLat.semicirclesAsDegrees()),
            subtitle: Text('end position'),
          ),
          ListTile(
            leading: Icon(Icons.power),
            title: Text(lap.db.intensity.toString()),
            subtitle: Text('intensity'),
          ),
          ListTile(
            leading: Icon(Icons.shutter_speed),
            title: Text((lap.db.avgSpeed * 3.6).toStringAsFixed(2) +
                " km/h / " +
                (lap.db.maxSpeed * 3.6).toStringAsFixed(2) +
                " km/h"),
            subtitle: Text('avg / max speed'),
          ),
        ],
      ),
    );
  }
}
