import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/charts/athlete_charts/athlete_stride_ratio_chart.dart';

class AthleteStrideRatioWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteStrideRatioWidget({this.athlete});

  @override
  _AthleteStrideRatioWidgetState createState() =>
      _AthleteStrideRatioWidgetState();
}

class _AthleteStrideRatioWidgetState extends State<AthleteStrideRatioWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var strideRatioActivities = activities
          .where((value) =>
              value.db.avgStrideRatio != null && value.db.avgStrideRatio > 0)
          .toList();

      if (strideRatioActivities.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteStrideRatioChart(activities: strideRatioActivities),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No stride ratio data available."),
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
