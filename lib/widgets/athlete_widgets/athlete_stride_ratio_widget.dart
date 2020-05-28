import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthleteStrideRatioWidget extends StatefulWidget {
  const AthleteStrideRatioWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthleteStrideRatioWidgetState createState() =>
      _AthleteStrideRatioWidgetState();
}

class _AthleteStrideRatioWidgetState extends State<AthleteStrideRatioWidget> {
  List<Activity> activities = <Activity>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isNotEmpty) {
      final List<Activity> strideRatioActivities = activities
          .where((Activity value) =>
              value.db.avgStrideRatio != null && value.db.avgStrideRatio > 0)
          .toList();

      if (strideRatioActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
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
        return const Center(
          child: Text('No stride ratio data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Athlete athlete = widget.athlete;
    activities = await athlete.activities;
    setState(() {});
  }
}
