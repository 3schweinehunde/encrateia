import 'package:encrateia/models/weight.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/widgets/charts/athlete_charts/athlete_ecor_chart.dart';

class AthleteEcorWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteEcorWidget({this.athlete});

  @override
  _AthleteEcorWidgetState createState() => _AthleteEcorWidgetState();
}

class _AthleteEcorWidgetState extends State<AthleteEcorWidget> {
  List<Activity> activities = [];
  double anyWeight;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var ecorActivities = activities
          .where((activity) =>
              activity.db.avgPower != null &&
              activity.db.avgPower > 0 &&
              activity.db.avgSpeed != null)
          .toList();

      if (ecorActivities.length > 0 && anyWeight != null) {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteEcorChart(activities: ecorActivities),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No Ecor available."),
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
    anyWeight = await Weight.getBy(
      athletesId: widget.athlete.db.id,
      date: DateTime.now(),
    );
    setState(() {});
  }
}
