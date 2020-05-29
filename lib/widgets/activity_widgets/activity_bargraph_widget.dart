import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/utils/my_bar_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_powerZones.isNotEmpty && _laps.isNotEmpty) {
      return DataTable(
          showCheckboxColumn: false,
          onSelectAll: (_) {},
          columns: const <DataColumn>[
            DataColumn(label: Text('Title'), numeric: false),
            DataColumn(label: Text('Value'), numeric: true),
            DataColumn(label: Text('Bar'), numeric: false),
          ],
          rows: <DataRow>[
            const DataRow(cells: <DataCell>[
              DataCell(Text('Power')),
              DataCell(Text('')),
              DataCell(Text('')),
            ]),

            DataRow(cells: <DataCell>[
              const DataCell(Text('Activity')),
              DataCell(
                Text(widget.activity.db.avgPower.toStringAsFixed(1)),
              ),
              DataCell(
                MyBarChart(
                  value: widget.activity.db.avgPower,
                  powerZones: _powerZones,
                ),
              ),
            ]),
            for (Lap lap in _laps)
              DataRow(cells: <DataCell>[
                DataCell(Text('Lap ' + lap.index.toString())),
                DataCell(
                  Text(lap.db.avgPower.toStringAsFixed(1)),
                ),
                DataCell(
                  MyBarChart(
                    value: lap.db.avgPower,
                    powerZones: _powerZones,
                  ),
                ),
              ]),
            const DataRow(cells: <DataCell>[
              DataCell(Text('Heart Rate')),
              DataCell(Text('')),
              DataCell(Text('')),
            ]),
            DataRow(cells: <DataCell>[
              const DataCell(Text('Activity')),
              DataCell(Text(
                widget.activity.db.avgHeartRate.toString(),
              )),
              DataCell(
                MyBarChart(
                  value: widget.activity.db.avgHeartRate,
                  heartRateZones: _heartRateZones,
                ),
              )
            ]),
            for (Lap lap in _laps)
              DataRow(cells: <DataCell>[
                DataCell(Text('Lap ' + lap.index.toString())),
                DataCell(
                  Text(lap.db.avgHeartRate.toString()),
                ),
                DataCell(
                  MyBarChart(
                    value: lap.db.avgHeartRate,
                    heartRateZones: _heartRateZones,
                  ),
                ),
              ]),
          ]);
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    _laps = await activity.laps;

    _powerZoneSchema = await activity.powerZoneSchema;
    if (_powerZoneSchema != null)
      _powerZones = await _powerZoneSchema.powerZones;

    _heartRateZoneSchema = await activity.heartRateZoneSchema;
    if (_heartRateZoneSchema != null)
      _heartRateZones = await _heartRateZoneSchema.heartRateZones;
    setState(() {});
  }
}
