import 'dart:math';
import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/bar_zone.dart';
import '/models/heart_rate_zone.dart';
import '/models/heart_rate_zone_schema.dart';
import '/models/lap.dart';
import '/models/power_zone.dart';
import '/models/power_zone_schema.dart';
import '/utils/enums.dart';
import '/utils/my_bar_chart.dart';
import '/utils/pg_text.dart';

class ActivityBarGraphWidget extends StatefulWidget {
  const ActivityBarGraphWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  ActivityBarGraphWidgetState createState() => ActivityBarGraphWidgetState();
}

class ActivityBarGraphWidgetState extends State<ActivityBarGraphWidget> {
  PowerZoneSchema? _powerZoneSchema;
  HeartRateZoneSchema? _heartRateZoneSchema;
  List<PowerZone> _powerZones = <PowerZone>[];
  List<HeartRateZone> _heartRateZones = <HeartRateZone>[];
  List<Lap> _laps = <Lap>[];
  List<BarZone> _heartRateDistributions = <BarZone>[];
  List<BarZone> _powerDistributions = <BarZone>[];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_powerZones.isNotEmpty && _laps.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 500,
          child: ListView(padding: const EdgeInsets.all(20), children: <Widget>[
            Table(columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(60),
              1: FixedColumnWidth(160),
              2: FixedColumnWidth(60),
              3: FixedColumnWidth(160),
              4: FixedColumnWidth(60),
            }, children: <TableRow>[
              const TableRow(children: <Widget>[
                Text('Title\n'),
                Text('Average Power'),
                Text('Watts'),
                Text('Average Heart Rate'),
                Text('bpm'),
              ]),
              TableRow(children: <Widget>[
                const Text('Activity'),
                MyBarChart(
                  width: 150,
                  height: 20,
                  value: widget.activity!.avgPower!,
                  powerZones: _powerZones,
                ),
                Text((widget.activity!.avgPower! > 0)
                    ? widget.activity!.avgPower!.toStringAsFixed(1)
                    : ''),
                MyBarChart(
                  width: 150,
                  height: 20,
                  value: widget.activity!.avgHeartRate!,
                  heartRateZones: _heartRateZones,
                ),
                Text(widget.activity!.avgHeartRate.toString()),
              ]),
              for (Lap lap in _laps)
                TableRow(children: <Widget>[
                  Text('Lap ${lap.index}'),
                  MyBarChart(
                    width: 150,
                    height: 20,
                    value: lap.avgPower!,
                    powerZones: _powerZones,
                  ),
                  Text((lap.avgPower! > 0)
                      ? lap.avgPower!.toStringAsFixed(1)
                      : ''),
                  MyBarChart(
                    width: 150,
                    height: 20,
                    value: lap.avgHeartRate!,
                    heartRateZones: _heartRateZones,
                  ),
                  Text(lap.avgHeartRate.toString()),
                ]),
            ]),
            const SizedBox(height: 40),
            Table(columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(60),
              1: FixedColumnWidth(210),
              2: FixedColumnWidth(210),
            }, children: <TableRow>[
              const TableRow(children: <Widget>[
                Text('Title\n'),
                Text('Power Zone Distribution'),
                Text('Heart Rate Zone Distribution'),
              ]),
              TableRow(children: <Widget>[
                const Text('Activity'),
                MyBarChart.visualizeDistributions(
                  height: 20,
                  distributions: _heartRateDistributions,
                ),
                MyBarChart.visualizeDistributions(
                  height: 20,
                  distributions: _powerDistributions,
                ),
              ]),
              for (Lap lap in _laps)
                TableRow(children: <Widget>[
                  Text('Lap ${lap.index}'),
                  MyBarChart.visualizeDistributions(
                    height: 20,
                    distributions: lap.powerDistributions,
                  ),
                  MyBarChart.visualizeDistributions(
                    height: 20,
                    distributions: lap.heartRateDistributions,
                  ),
                ]),
            ]),
            const SizedBox(height: 40),
            Table(columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(60),
              1: FixedColumnWidth(210),
              2: FixedColumnWidth(60),
            }, children: <TableRow>[
              const TableRow(children: <Widget>[
                Text('Title\n'),
                Text('Average Pace'),
                Text('min/km'),
              ]),
              TableRow(children: <Widget>[
                const Text('Activity'),
                MyBarChart(
                  height: 20,
                  value: widget.activity!.avgSpeed!,
                  maximum:
                      _laps.map((Lap lap) => lap.avgSpeed ?? 0).reduce(max),
                ),
                PQText(value: widget.activity!.avgSpeed, pq: PQ.paceFromSpeed),
              ]),
              for (Lap lap in _laps)
                TableRow(children: <Widget>[
                  Text('Lap ${lap.index}'),
                  MyBarChart(
                    height: 20,
                    value: lap.avgSpeed!,
                    maximum:
                        _laps.map((Lap lap) => lap.avgSpeed ?? 0).reduce(max),
                  ),
                  PQText(value: lap.avgSpeed, pq: PQ.paceFromSpeed),
                ]),
            ]),
          ]),
        ),
      );
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity!;
    _laps = await activity.laps;
    for (final Lap lap in _laps) {
      lap.powerDistributions = await lap.powerZoneCounts();
      lap.heartRateDistributions = await lap.heartRateZoneCounts();
    }

    _powerZoneSchema = await activity.powerZoneSchema;
    if (_powerZoneSchema != null) {
      _powerZones = await _powerZoneSchema!.powerZones;
    }

    _heartRateDistributions = await activity.powerZoneCounts();
    _powerDistributions = await activity.heartRateZoneCounts();

    _heartRateZoneSchema = await activity.heartRateZoneSchema;
    if (_heartRateZoneSchema != null) {
      _heartRateZones = await _heartRateZoneSchema!.heartRateZones;
    }

    setState(() => loading = false);
  }
}
