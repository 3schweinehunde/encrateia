import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/interval.dart' as encrateia;
import '/screens/select_interval_screen.dart';
import '/screens/show_interval_screen.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/my_button.dart';

class IntervalsListWidget extends StatefulWidget {
  const IntervalsListWidget({
    required this.activity,
    required this.athlete,
  });

  final Activity? activity;
  final Athlete? athlete;

  @override
  _IntervalsListWidgetState createState() => _IntervalsListWidgetState();
}

class _IntervalsListWidgetState extends State<IntervalsListWidget> {
  List<encrateia.Interval> intervals = <encrateia.Interval>[];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            const Spacer(),
            MyButton.add(
                child: const Text('Specify an Interval'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) => SelectIntervalScreen(
                        athlete: widget.athlete,
                        activity: widget.activity,
                      ),
                    ),
                  );
                  getData();
                }),
            const Spacer(),
          ]),
          if (intervals.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showCheckboxColumn: false,
                columnSpacing: 10,
                onSelectAll: (_) {},
                columns: const <DataColumn>[
                  DataColumn(label: Text('Interval'), numeric: true),
                  DataColumn(label: Text('Heart Rate'), numeric: true),
                  DataColumn(label: Text('Pace\n(calculated)'), numeric: true),
                  DataColumn(label: Text('Power'), numeric: true),
                  DataColumn(label: Text('Distance'), numeric: true),
                  DataColumn(label: Text('Ascent'), numeric: true),
                  DataColumn(label: Text('Moving Time'), numeric: true),
                ],
                rows: intervals.map((encrateia.Interval interval) {
                  return DataRow(
                    key: ValueKey<int?>(interval.id),
                    onSelectChanged: (bool? selected) async {
                      if (selected!) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) =>
                                ShowIntervalScreen(
                              interval: interval,
                              intervals: intervals,
                              athlete: widget.athlete,
                              activity: widget.activity,
                            ),
                          ),
                        );
                        getData();
                      }
                    },
                    cells: <DataCell>[
                      DataCell(PQText(value: interval.index, pq: PQ.integer)),
                      DataCell(PQText(
                        value: interval.avgHeartRate,
                        pq: PQ.heartRate,
                      )),
                      DataCell(PQText(
                        value: interval.avgSpeedByDistance,
                        pq: PQ.paceFromSpeed,
                      )),
                      DataCell(PQText(value: interval.avgPower, pq: PQ.power)),
                      DataCell(
                          PQText(value: interval.distance, pq: PQ.distance)),
                      DataCell(
                        PQText(
                          value: (interval.totalAscent ?? 0) -
                              (interval.totalDescent ?? 0),
                          pq: PQ.elevation,
                        ),
                      ),
                      DataCell(PQText(
                        value: interval.movingTime,
                        pq: PQ.shortDuration,
                      ))
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    intervals = await widget.activity!.intervals;
    setState(() => loading = false);
  }
}
