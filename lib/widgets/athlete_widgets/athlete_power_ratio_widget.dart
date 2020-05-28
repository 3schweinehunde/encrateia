import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthletePowerRatioWidget extends StatefulWidget {
  const AthletePowerRatioWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthletePowerRatioWidgetState createState() =>
      _AthletePowerRatioWidgetState();
}

class _AthletePowerRatioWidgetState extends State<AthletePowerRatioWidget> {
  List<Activity> activities = <Activity>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isNotEmpty) {
      final List<Activity> powerRatioActivities = activities
          .where((Activity value) =>
              value.db.avgPower != null &&
              value.db.avgPower > 0 &&
              value.db.avgFormPower != null &&
              value.db.avgFormPower > 0)
          .toList();

      if (powerRatioActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: powerRatioActivities,
                chartTitleText: 'Power Ratio (%)',
                activityAttr: ActivityAttr.avgPowerRatio,
                athlete: widget.athlete,
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No power ratio data available.'),
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
