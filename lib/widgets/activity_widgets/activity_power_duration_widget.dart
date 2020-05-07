import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import '../charts/power_duration_chart.dart';

class ActivityPowerDurationWidget extends StatelessWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityPowerDurationWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  Widget build(context) {
    return FutureBuilder<List<Event>>(
      future: activity.records,
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          var powerRecords = snapshot.data
              .where((value) => value.db.power != null && value.db.power > 100)
              .toList();

          if (powerRecords.length > 0) {
            return SingleChildScrollView(
              child: PowerDurationChart(records: powerRecords),
            );
          } else {
            return Center(
              child: Text("No power data available."),
            );
          }
        } else {
          return Container(
            height: 100,
            child: Center(child: Text("Loading")),
          );
        }
      },
    );
  }
}
