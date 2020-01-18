import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/screens/show_lap_screen.dart';

class LapsListWidget extends StatelessWidget {
  final Activity activity;

  LapsListWidget({this.activity});

  @override
  Widget build(context) {
    return FutureBuilder<List<Lap>>(
      future: Lap.by(activity: activity),
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        Widget widget;

        if (snapshot.hasData) {
          widget = DataTable(
            dataRowHeight: kMinInteractiveDimension * 0.60,
            columnSpacing: 20,
            columns: <DataColumn>[
              const DataColumn(
                label: Icon(Icons.loop),
                tooltip: 'Lap',
                numeric: true,
              ),
              const DataColumn(
                label: Text("bpm"),
                tooltip: 'heartrate',
                numeric: true,
              ),
              const DataColumn(
                label: Text("km/h"),
                tooltip: 'speed',
                numeric: true,
              ),
              const DataColumn(
                label: Icon(Icons.swap_calls),
                tooltip: 'distance',
                numeric: true,
              ),
              const DataColumn(
                label: Icon(Icons.trending_up),
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
                        builder: (context) => ShowLapScreen(
                          lap: lap,
                        ),
                      ),
                    );
                  }
                },
                cells: [
                  DataCell(
                    Text(lap.index.toString()),
                  ),
                  DataCell(
                    Text(lap.db.avgHeartRate.toString()),
                  ),
                  DataCell(
                    Text((lap.db.avgSpeed * 3.6).toStringAsFixed(2)),
                  ),
                  DataCell(
                    Text((lap.db.totalDistance / 1000).toStringAsFixed(3) +
                        ' km'),
                  ),
                  DataCell(
                    Text((lap.db.totalAscent - lap.db.totalDescent).toString()),
                  ),
                ],
              );
            }).toList(),
          );
        } else {
          widget = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Loading...'),
                )
              ],
            ),
          );
        }
        return widget;
      },
    );
  }
}
