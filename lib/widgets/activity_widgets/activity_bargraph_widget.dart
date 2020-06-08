import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/bar_zone.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/utils/my_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/date_time_utils.dart';

class ActivityBarGraphWidget extends StatefulWidget {
  const ActivityBarGraphWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityBarGraphWidgetState createState() => _ActivityBarGraphWidgetState();
}

class _ActivityBarGraphWidgetState extends State<ActivityBarGraphWidget> {
  PowerZoneSchema _powerZoneSchema;
  HeartRateZoneSchema _heartRateZoneSchema;
  List<PowerZone> _powerZones = <PowerZone>[];
  List<HeartRateZone> _heartRateZones = <HeartRateZone>[];
  List<Lap> _laps = <Lap>[];
  List<BarZone> _heartRateDistributions = <BarZone>[];
  List<BarZone> _powerDistributions = <BarZone>[];

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
        child: Container(
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
                  value: widget.activity.db.avgPower,
                  powerZones: _powerZones,
                ),
                Text(widget.activity.db.avgPower.toStringAsFixed(1)),
                MyBarChart(
                  width: 150,
                  height: 20,
                  value: widget.activity.db.avgHeartRate,
                  heartRateZones: _heartRateZones,
                ),
                Text(widget.activity.db.avgHeartRate.toString()),
              ]),
              for (Lap lap in _laps)
                TableRow(children: <Widget>[
                  Text('Lap ' + lap.index.toString()),
                  MyBarChart(
                    width: 150,
                    height: 20,
                    value: lap.avgPower,
                    powerZones: _powerZones,
                  ),
                  Text(lap.avgPower.toStringAsFixed(1)),
                  MyBarChart(
                    width: 150,
                    height: 20,
                    value: lap.avgHeartRate,
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
                  Text('Lap ' + lap.index.toString()),
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
                  value: widget.activity.db.avgSpeed.toPaceDouble(),
                  maximum: 700,
                ),
                Text(widget.activity.db.avgSpeed.toPace()),
              ]),
              for (Lap lap in _laps)
                TableRow(children: <Widget>[
                  Text('Lap ' + lap.index.toString()),
                  MyBarChart(
                    height: 20,
                    value: lap.avgSpeed.toPaceDouble(),
                    maximum: 700,
                  ),
                  Text(lap.avgSpeed.toPace()),
                ]),
            ]),
          ]),
        ),
      );
    } else {
      return const Center(child: Text('Loading'));
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    _laps = await activity.laps;
    for (final Lap _lap in _laps) {
      _lap.powerDistributions = await _lap.powerZoneCounts();
      _lap.heartRateDistributions = await _lap.heartRateZoneCounts();
    }

    _powerZoneSchema = await activity.powerZoneSchema;
    if (_powerZoneSchema != null)
      _powerZones = await _powerZoneSchema.powerZones;

    _heartRateDistributions = await activity.powerZoneCounts();
    _powerDistributions = await activity.heartRateZoneCounts();

    _heartRateZoneSchema = await activity.heartRateZoneSchema;
    if (_heartRateZoneSchema != null)
      _heartRateZones = await _heartRateZoneSchema.heartRateZones;
    setState(() {});
  }
}
