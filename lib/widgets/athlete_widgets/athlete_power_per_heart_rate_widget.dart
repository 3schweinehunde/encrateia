import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthletePowerPerHeartRateWidget extends StatefulWidget {
  const AthletePowerPerHeartRateWidget({this.athlete});

  final Athlete athlete;
  
  @override
  _AthletePowerPerHeartRateWidgetState createState() =>
      _AthletePowerPerHeartRateWidgetState();
}

class _AthletePowerPerHeartRateWidgetState
    extends State<AthletePowerPerHeartRateWidget> {
  List<Activity> activities = <Activity>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isNotEmpty) {
      final List<Activity> powerPerHeartRateActivities = activities
          .where((Activity value) =>
              value.db.avgPower != null &&
              value.db.avgPower > 0 &&
              value.db.avgHeartRate != null &&
              value.db.avgHeartRate > 0 &&
              value.db.avgHeartRate != 255)
          .toList();

      if (powerPerHeartRateActivities.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: powerPerHeartRateActivities,
                activityAttr: ActivityAttr.avgPowerPerHeartRate,
                chartTitleText: 'Average power per heart rate',
                athlete: widget.athlete,
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No power per heart rate data available.'),
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
