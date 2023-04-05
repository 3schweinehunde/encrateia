import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/interval.dart' as encrateia;
import '/models/lap.dart';
import '/models/record_list.dart';
import '/screens/show_lap_screen.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/my_button.dart';

class LapsListWidget extends StatefulWidget {
  const LapsListWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  LapsListWidgetState createState() => LapsListWidgetState();
}

class LapsListWidgetState extends State<LapsListWidget> {
  List<Lap> laps = <Lap>[];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (laps.isNotEmpty) {
      return SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showCheckboxColumn: false,
            onSelectAll: (_) {},
            columns: const <DataColumn>[
              DataColumn(label: Text('Lap'), numeric: true),
              DataColumn(label: Text('Copy to interval'), numeric: false),
              DataColumn(label: Text('Heart Rate'), numeric: true),
              DataColumn(label: Text('Pace'), numeric: true),
              DataColumn(label: Text('Power'), numeric: true),
              DataColumn(label: Text('Dist.'), numeric: true),
              DataColumn(label: Text('Ascent'), numeric: true),
              DataColumn(label: Text('Moving Time'), numeric: true),
              DataColumn(label: Text('Total Timer Time'), numeric: true),
            ],
            rows: laps.map((Lap lap) {
              return DataRow(
                key: ValueKey<int?>(lap.id),
                onSelectChanged: (bool? selected) {
                  if (selected!) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) => ShowLapScreen(
                          lap: lap,
                          laps: laps,
                          athlete: widget.athlete,
                        ),
                      ),
                    );
                  }
                },
                cells: <DataCell>[
                  DataCell(PQText(value: lap.index, pq: PQ.integer)),
                  DataCell(MyButton.copy(
                      onPressed: (lap.copied == true)
                          ? null
                          : () => copyToInterval(lap: lap))),
                  DataCell(PQText(value: lap.avgHeartRate, pq: PQ.heartRate)),
                  DataCell(PQText(value: lap.avgSpeed, pq: PQ.paceFromSpeed)),
                  DataCell(PQText(value: lap.avgPower, pq: PQ.power)),
                  DataCell(PQText(value: lap.totalDistance, pq: PQ.distance)),
                  DataCell(
                    PQText(
                      value: (lap.totalAscent ?? 0) - (lap.totalDescent ?? 0),
                      pq: PQ.elevation,
                    ),
                  ),
                  DataCell(PQText(value: lap.movingTime, pq: PQ.shortDuration)),
                  DataCell(
                      PQText(value: lap.totalTimerTime, pq: PQ.shortDuration)),
                ],
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> copyToInterval({required Lap lap}) async {
    final List<Event> records = await lap.records;

    final encrateia.Interval interval = encrateia.Interval()
      ..athletesId = widget.athlete!.id
      ..activitiesId = widget.activity!.id
      ..firstRecordId = records.first.id
      ..firstDistance = records.first.distance
      ..lastRecordId = records.last.id
      ..lastDistance = records.last.distance;

    await interval.calculateAndSave(records: RecordList<Event>(records));
    await interval.copyTaggings(lap: lap);
    lap.copied = true;
    widget.activity!.cachedIntervals = <encrateia.Interval>[];
    setState(() {});
  }

  Future<void> getData() async {
    laps = await widget.activity!.laps;
    setState(() => loading = false);
  }
}
