import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'lap_power_duration_chart.dart';

class LapPowerDurationWidget extends StatelessWidget {
  final Lap lap;

  LapPowerDurationWidget({this.lap});

  @override
  Widget build(context) {
    return FutureBuilder<List<Event>>(
      future: Event.recordsByLap(lap: lap),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          var powerValues =
              snapshot.data.map((value) => value.db.power).nonZero();
          if (powerValues.length > 0) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  LapPowerDurationChart(records: snapshot.data),
                ]);
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
