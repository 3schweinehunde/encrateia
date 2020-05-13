import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthleteEcorWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteEcorWidget({this.athlete});

  @override
  _AthleteEcorWidgetState createState() => _AthleteEcorWidgetState();
}

class _AthleteEcorWidgetState extends State<AthleteEcorWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length == 0) {
      return Center(
        child: Text("Loading"),
      );
    } else {
      var ecorActivities = activities
          .where((activity) =>
              activity.db.avgPower != null &&
              activity.db.avgPower > 0 &&
              activity.db.avgSpeed != null)
          .toList();
      if (ecorActivities.length == 0) {
        return Center(
          child: Text("No ecor data available."),
        );
      } else if (ecorActivities.first.weight == null) {
        return Center(
          child: Text("Please enter your (historical) weight in the settings."),
        );
      } else {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: ecorActivities,
                chartTitleText: 'Ecor (W s/kg m)',
                activityAttr: ActivityAttr.ecor,
                athlete: widget.athlete,
              )
            ],
          ),
        );
      }
    }
  }

  getData() async {
    Athlete athlete = widget.athlete;
    activities = await athlete.activities;

    for (Activity activity in activities) {
      Weight weight = await Weight.getBy(
        athletesId: activity.db.athletesId,
        date: activity.db.timeCreated,
      );
      activity.weight = weight?.db?.value;
    }
    setState(() {});
  }
}
