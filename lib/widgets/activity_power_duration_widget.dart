import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'power_duration_chart.dart';

class ActivityPowerDurationWidget extends StatelessWidget {
  final Activity activity;

  ActivityPowerDurationWidget({this.activity});

  @override
  Widget build(context) {
    return FutureBuilder<List<Event>>(
      future: Event.by(activity: activity),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          var powerValues =
              snapshot.data.map((value) => value.db.power).nonZero();
          if (powerValues.length > 0) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PowerDurationChart(records: snapshot.data),
              ],
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
      },
    );
  }
}
