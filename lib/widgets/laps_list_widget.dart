import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/screens/show_lap_screen.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/num_utils.dart';

class LapsListWidget extends StatelessWidget {
  final Activity activity;

  LapsListWidget({this.activity});

  @override
  Widget build(context) {
    return FutureBuilder<List<Lap>>(
      future: Lap.by(activity: activity),
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: DataTable(
              dataRowHeight: kMinInteractiveDimension * 0.60,
              columnSpacing: 1,
              columns: <DataColumn>[
                DataColumn(
                  label: MyIcon.repeats,
                  tooltip: 'Lap',
                  numeric: true,
                ),
                DataColumn(
                  label: Text("bpm"),
                  tooltip: 'heartrate',
                  numeric: true,
                ),
                DataColumn(
                  label: Text("min:ss"),
                  tooltip: 'pace',
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Watts"),
                  tooltip: 'power',
                  numeric: true,
                ),
                DataColumn(
                  label: Text("km"),
                  tooltip: 'distance',
                  numeric: true,
                ),
                DataColumn(
                  label: MyIcon.ascent,
                  tooltip: 'ascent',
                  numeric: true,
                ),
              ],
              rows: snapshot.data.map((Lap lap) {
                return DataRow(
                  key: Key(lap.db.id.toString()),
                  onSelectChanged: (bool selected) {
                    if (selected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowLapScreen(lap: lap),
                        ),
                      );
                    }
                  },
                  cells: [
                    DataCell(Text(lap.index.toString())),
                    DataCell(Text(lap.db.avgHeartRate.toString())),
                    DataCell(Text(lap.db.avgSpeed.toPace())),
                    DataCell(Text(lap.db.avgPower.toStringOrDashes(1))),
                    DataCell(
                      Text((lap.db.totalDistance / 1000).toStringAsFixed(2)),
                    ),
                    DataCell(
                      Text((lap.db.totalAscent - lap.db.totalDescent)
                          .toString()),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        } else {
          return Center(
            child: Text("Loading"),
          );
        }
      },
    );
  }
}
