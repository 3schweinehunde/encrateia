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
            leading: Icon(Icons.event),
            title: Text(lap.db.event),
            subtitle: Text("event"),
          ),
          ListTile(
            leading: Icon(Icons.directions_bike),
            title: Text(lap.db.sport + ' / ' + lap.db.subSport),
            subtitle: Text('sport / sub sport'),
          ),
        ],
      ),
    );
  }
}

// timeStamp    datetime
// startTime    datetime
// startPositionLat     real
// startPositionLong    real
// endPositionLat     real
// endPositionLong    real
// avgHeartRate     integer
// maxHeartRate     integer
// avgRunningCadence    real
// eventType    text
// eventGroup     integer
// avgVerticalOscillation     real
// totalElapsedTime     integer
// totalTimerTime     integer
// totalDistance    integer
// totalStrides     integer
// totalCalories    integer
// avgSpeed     real
// maxSpeed     real
// totalAscent    integer
// totalDescent     integer
// avgStanceTimePercent     real
// avgStanceTime    real
// maxRunningCadence    integer
// intensity    integer
// lapTrigger     text
// avgTemperature     integer
// maxTemperature     integer
// avgFractionalCadence     real
// maxFractionalCadence     real
// totalFractionalCycles    real
