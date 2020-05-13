import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthleteSpeedPerHeartRateWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteSpeedPerHeartRateWidget({this.athlete});

  @override
  _AthleteSpeedPerHeartRateWidgetState createState() =>
      _AthleteSpeedPerHeartRateWidgetState();
}

class _AthleteSpeedPerHeartRateWidgetState
    extends State<AthleteSpeedPerHeartRateWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var speedPerHeartRateActivities = activities
          .where((value) =>
              value.db.avgSpeed != null &&
              value.db.avgSpeed > 0 &&
              value.db.avgHeartRate != null &&
              value.db.avgHeartRate > 0 &&
              value.db.avgHeartRate != 255)
          .toList();

      if (speedPerHeartRateActivities.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: speedPerHeartRateActivities,
                activityAttr: ActivityAttr.avgSpeedPerHeartRate,
                chartTitleText: 'Average speed per heart rate',
                athlete: widget.athlete,
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No speed per heart rate data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    Athlete athlete = widget.athlete;
    activities = await athlete.activities;
    activities =
        activities.where((activity) => activity.db.sport == "running").toList();
    setState(() {});
  }
}
