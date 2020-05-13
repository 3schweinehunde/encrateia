import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

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
              AthleteTimeSeriesChart(
                activities: strideRatioActivities,
                activityAttr: ActivityAttr.avgStrideRatio,
                chartTitleText: 'Stride Ratio',
                athlete: widget.athlete,
              ),
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
