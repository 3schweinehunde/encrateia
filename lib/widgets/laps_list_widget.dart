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
              horizontalMargin: 12,
              onSelectAll: (_){},
              columns: <DataColumn>[
                DataColumn(
                  label: Text("Lap"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("HR\nbpm"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Pace\nmin:ss"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Power\nWatts"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Dist.\nkm"),
                  numeric: true,
                ),
                DataColumn(
                  label: Text("Ascent\nm"),
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
