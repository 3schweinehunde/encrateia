import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/list_utils.dart';
import '../charts/athlete_charts/athlete_power_chart.dart';

class AthletePowerWidget extends StatefulWidget {
  final Athlete athlete;

  AthletePowerWidget({this.athlete});

  @override
  _AthletePowerWidgetState createState() => _AthletePowerWidgetState();
}

class _AthletePowerWidgetState extends State<AthletePowerWidget> {
  List<Activity> activities = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (activities.length > 0) {
      var powerValues = activities.map((value) => value.db.avgPower).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              AthletePowerChart(activities: activities),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No power data available."),
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