import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/select_interval_screen.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/screens/show_interval_screen.dart';

class IntervalsListWidget extends StatefulWidget {
  const IntervalsListWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

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
            DataTable(
              showCheckboxColumn: false,
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
                  key: ValueKey<int>(interval.id),
                  onSelectChanged: (bool selected) {
                    if (selected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => ShowIntervalScreen(
                            interval: interval,
                            intervals: intervals,
                            athlete: widget.athlete,
                          ),
                        ),
                      );
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
                    DataCell(PQText(value: interval.distance, pq: PQ.distance)),
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
        ],
      ),
    );
  }

  Future<void> getData() async {
    intervals = await widget.activity.intervals;
    setState(() => loading = false);
  }
}
