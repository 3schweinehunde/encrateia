import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthleteSpeedPerHeartRateWidget extends StatefulWidget {
  const AthleteSpeedPerHeartRateWidget({this.athlete});

  final Athlete athlete;
  
  @override
  _AthleteSpeedPerHeartRateWidgetState createState() =>
      _AthleteSpeedPerHeartRateWidgetState();
}

class _AthleteSpeedPerHeartRateWidgetState
    extends State<AthleteSpeedPerHeartRateWidget> {
  List<Activity> activities = <Activity>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isNotEmpty) {
      final List<Activity> speedPerHeartRateActivities = activities
          .where((Activity value) =>
              value.db.avgSpeed != null &&
              value.db.avgSpeed > 0 &&
              value.db.avgHeartRate != null &&
              value.db.avgHeartRate > 0 &&
              value.db.avgHeartRate != 255)
          .toList();

      if (speedPerHeartRateActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
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
        return const Center(
          child: Text('No speed per heart rate data available.'),
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
    activities =
        activities.where((Activity activity) => activity.db.sport == 'running').toList();
    setState(() {});
  }
}
