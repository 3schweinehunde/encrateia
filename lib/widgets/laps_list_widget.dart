import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/lap.dart';

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
            columns: <DataColumn>[
              const DataColumn(label: Icon(Icons.loop), tooltip: 'Lap'),
              const DataColumn(label: Text("bpm"), tooltip: 'heartrate'),
              const DataColumn(label: Text("km/h"), tooltip: 'speed'),
              const DataColumn(
                  label: Icon(Icons.trending_up), tooltip: 'ascent'),
            ],
            rows: snapshot.data.map((Lap lap) {
              return DataRow(key: Key(lap.db.id.toString()), cells: [
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
                  Text((lap.db.totalAscent - lap.db.totalDescent).toString()),
                ),
              ]);
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
