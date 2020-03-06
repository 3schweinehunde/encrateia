import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/charts/athlete_charts/athlete_power_per_heart_rate_chart.dart';

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
              value.db.avgHeartRate > 0)
          .toList();

      if (powerPerHeartRateActivities.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthletePowerPerHeartRateChart(
                activities: powerPerHeartRateActivities,
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
