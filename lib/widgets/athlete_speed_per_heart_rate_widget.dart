import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'athlete_speed_per_heart_rate_chart.dart';

class AthleteSpeedPerHeartRateWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteSpeedPerHeartRateWidget({this.athlete});

  @override
  _AthleteSpeedPerHeartRateWidgetState createState() => _AthleteSpeedPerHeartRateWidgetState();
}

class _AthleteSpeedPerHeartRateWidgetState extends State<AthleteSpeedPerHeartRateWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var powerValues = activities.map((value) => value.db.avgSpeed).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteSpeedPerHeartRateChart(activities: activities),
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
    activities = activities.where((activity) => activity.db.sport == "running").toList();
    setState(() {});
  }
}
