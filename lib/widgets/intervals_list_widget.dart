import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/select_interval_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/screens/show_lap_screen.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/num_utils.dart';

class IntervalsListWidget extends StatelessWidget {
  const IntervalsListWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<encrateia.Interval>>(
      future: activity.intervals,
      builder: (BuildContext context,
          AsyncSnapshot<List<encrateia.Interval>> snapshot) {
        if (snapshot.hasData) {
          final List<encrateia.Interval> intervals = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                MyButton.add(
                  child: const Text('Specify an Interval'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) => SelectIntervalScreen(
                        athlete: athlete,
                        activity: activity,
                      ),
                    ),
                  ),
                ),
                DataTable(
                  showCheckboxColumn: false,
                  onSelectAll: (_) {},
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Lap'), numeric: true),
                    DataColumn(label: Text('HR\nbpm'), numeric: true),
                    DataColumn(label: Text('Pace\nmin:s'), numeric: true),
                    DataColumn(label: Text('Power\nWatt'), numeric: true),
                    DataColumn(label: Text('Dist.\nm'), numeric: true),
                    DataColumn(label: Text('Ascent\nm'), numeric: true),
                  ],
                  rows: intervals.map((encrateia.Interval interval) {
                    return DataRow(
                      key: ValueKey<int>(interval.id),
                      onSelectChanged: (bool selected) {
                        if (selected) {
                          Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                              builder: (BuildContext context) => ShowLapScreen(
                                lap: null,
                                laps: null,
                                athlete: athlete,
                              ),
                            ),
                          );
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(interval.index.toString())),
                        DataCell(
                            Text(avgHeartRateString(interval.avgHeartRate))),
                        DataCell(Text(interval.avgSpeed.toPace())),
                        DataCell(Text(interval.avgPower.toStringOrDashes(1))),
                        DataCell(
                          Text(interval.distance.toString()),
                        ),
                        DataCell(
                          Text((interval.totalAscent - interval.totalDescent)
                              .toString()),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Loading'),
          );
        }
      },
    );
  }

  String avgHeartRateString(int avgHeartRate) {
    if (avgHeartRate != 255)
      return avgHeartRate.toString();
    else
      return '-';
  }
}
