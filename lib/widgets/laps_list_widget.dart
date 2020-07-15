import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/screens/show_lap_screen.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/num_utils.dart';

class LapsListWidget extends StatelessWidget {
  const LapsListWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lap>>(
      future: activity.laps,
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          final List<Lap> laps = snapshot.data;
          return SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                onSelectAll: (_) {},
                columns: const <DataColumn>[
                  DataColumn(label: Text('Lap'), numeric: true),
                  DataColumn(label: Text('HR\nbpm'), numeric: true),
                  DataColumn(label: Text('Pace\nmin:s'), numeric: true),
                  DataColumn(label: Text('Power\nWatt'), numeric: true),
                  DataColumn(label: Text('Dist.\nkm'), numeric: true),
                  DataColumn(label: Text('Ascent\nm'), numeric: true),
                ],
                rows: laps.map((Lap lap) {
                  return DataRow(
                    key: ValueKey<int>(lap.id),
                    onSelectChanged: (bool selected) {
                      if (selected) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) => ShowLapScreen(
                              lap: lap,
                              laps: laps,
                              athlete: athlete,
                            ),
                          ),
                        );
                      }
                    },
                    cells: <DataCell>[
                      DataCell(Text(lap.index.toString())),
                      DataCell(Text(avgHeartRateString(lap.avgHeartRate))),
                      DataCell(Text(lap.avgSpeed.toPace())),
                      DataCell(Text(lap.avgPower.toStringOrDashes(1))),
                      DataCell(
                        Text((lap.totalDistance / 1000).toStringAsFixed(2)),
                      ),
                      DataCell(
                        Text((lap.totalAscent - lap.totalDescent)
                            .toString()),
                      ),
                    ],
                  );
                }).toList(),
              ),
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
