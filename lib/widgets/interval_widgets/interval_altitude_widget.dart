import 'dart:math';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/widgets/charts/lap_charts/lap_altitude_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class IntervalAltitudeWidget extends StatefulWidget {
  const IntervalAltitudeWidget({this.interval});

  final encrateia.Interval interval;

  @override
  _IntervalAltitudeWidgetState createState() => _IntervalAltitudeWidgetState();
}

class _IntervalAltitudeWidgetState extends State<IntervalAltitudeWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalAltitudeWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> altitudeRecords =
      records.where((Event value) => value.altitude != null).toList();

      if (altitudeRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapAltitudeChart(
                records: RecordList<Event>(altitudeRecords),
                minimum: altitudeRecords
                    .map((Event record) => record.altitude)
                    .reduce(min)
                    .toDouble(),
                maximum: altitudeRecords
                    .map((Event record) => record.altitude)
                    .reduce(max)
                    .toDouble(),
              ),
              const Text(
                  'Only records where altitude measurement is present are shown.'),
              const Text('Swipe left/write to compare with other intervals.'),
              const Divider(),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: altitudeRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No altitude data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    final encrateia.Interval interval = widget.interval;
    records = RecordList<Event>(await interval.records);

    setState(() => loading = false);
  }
}
