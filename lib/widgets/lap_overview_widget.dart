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
            leading: Icon(Icons.access_time),
            title: Text(DateFormat("dd MMM yyyy, h:mm:ss")
                .format(lap.db.startTime)),
            subtitle: Text('start time'),
          ),
        ],
      ),
    );
  }
}

// avgHeartRate     integer
// maxHeartRate     integer
// avgRunningCadence    real
// maxRunningCadence    integer
// totalDistance    integer
// totalStrides     integer
// totalCalories    integer
// avgSpeed     real
// maxSpeed     real
// totalAscent    integer
// totalDescent     integer
// intensity    integer

