import 'package:flutter/material.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/models/lap.dart';

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
            title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
                .format(lap.db.timeStamp)),
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
            title: Text(lap.db.eventType + " / " + lap.db.eventGroup.toString()),
            subtitle: Text('event type / group'),
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
        ],
      ),
    );
  }
}

// avgVerticalOscillation     real
// totalElapsedTime     integer
// totalTimerTime     integer
// avgStanceTimePercent     real
// avgStanceTime    real
// lapTrigger     text
// avgTemperature     integer
// maxTemperature     integer
// avgFractionalCadence     real
// maxFractionalCadence     real
// totalFractionalCycles    real
