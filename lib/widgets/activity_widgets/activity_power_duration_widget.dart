import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/power_duration_chart.dart';

class ActivityPowerDurationWidget extends StatelessWidget {
  const ActivityPowerDurationWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: activity.records,
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasData) {
          final List<Event> powerRecords = snapshot.data
              .where((Event value) =>
                  value.db.power != null && value.db.power > 100)
              .toList();

          if (powerRecords.isNotEmpty) {
            return SingleChildScrollView(
              child: PowerDurationChart(records: powerRecords),
            );
          } else {
            return const Center(
              child: Text('No power data available.'),
            );
          }
        } else {
          return Container(
            height: 100,
            child: const Center(
              child: Text('Loading'),
            ),
          );
        }
      },
    );
  }
}
