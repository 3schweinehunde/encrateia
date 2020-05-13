import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthletePowerWidget extends StatefulWidget {
  final Athlete athlete;

  AthletePowerWidget({this.athlete});

  @override
  _AthletePowerWidgetState createState() => _AthletePowerWidgetState();
}

class _AthletePowerWidgetState extends State<AthletePowerWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var powerActivities = activities
          .where((activity) =>
              activity.db.avgPower != null && activity.db.avgPower > 0)
          .toList();
      if (powerActivities.length > 0) {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: powerActivities,
                chartTitleText: 'Power (W)',
                activityAttr: ActivityAttr.avgPower,
                athlete: widget.athlete,
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No power data available."),
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
    setState(() {});
  }
}
