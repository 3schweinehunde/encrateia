import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/athlete_time_series_chart.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';

class AthleteEcorWidget extends StatefulWidget {
  const AthleteEcorWidget({this.athlete});

  final Athlete athlete;
  
  @override
  _AthleteEcorWidgetState createState() => _AthleteEcorWidgetState();
}

class _AthleteEcorWidgetState extends State<AthleteEcorWidget> {
  List<Activity> activities = <Activity>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Center(
        child: Text('Loading'),
      );
    } else {
      final List<Activity> ecorActivities = activities
          .where((Activity activity) =>
              activity.db.avgPower != null &&
              activity.db.avgPower > 0 &&
              activity.db.avgSpeed != null)
          .toList();
      if (ecorActivities.isEmpty) {
        return const Center(
          child: Text('No ecor data available.'),
        );
      } else if (ecorActivities.first.weight == null) {
        return const Center(
          child: Text('Please enter your (historical) weight in the settings.'),
        );
      } else {
        return ListTileTheme(
          iconColor: Colors.orange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              AthleteTimeSeriesChart(
                activities: ecorActivities,
                chartTitleText: 'Ecor (kJ / kg / km)',
                activityAttr: ActivityAttr.ecor,
                athlete: widget.athlete,
              )
            ],
          ),
        );
      }
    }
  }

  Future<void> getData() async {
    final Athlete athlete = widget.athlete;
    activities = await athlete.activities;

    // ignore: prefer_final_in_for_each
    for (Activity activity in activities) {
      final Weight weight = await Weight.getBy(
        athletesId: activity.db.athletesId,
        date: activity.db.timeCreated,
      );
      activity.weight = weight?.db?.value;
    }
    setState(() {});
  }
}
