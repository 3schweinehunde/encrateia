import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthletePowerPerHeartRateWidget extends StatefulWidget {
  final Athlete athlete;

  AthletePowerPerHeartRateWidget({this.athlete});

  @override
  _AthletePowerPerHeartRateWidgetState createState() =>
      _AthletePowerPerHeartRateWidgetState();
}

class _AthletePowerPerHeartRateWidgetState
    extends State<AthletePowerPerHeartRateWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var powerPerHeartRateActivities = activities
          .where((value) =>
              value.db.avgPower != null &&
              value.db.avgPower > 0 &&
              value.db.avgHeartRate != null &&
              value.db.avgHeartRate > 0 &&
              value.db.avgHeartRate != 255)
          .toList();

      if (powerPerHeartRateActivities.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
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
        return Center(
          child: Text("No power per heart rate data available."),
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
