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
        child: DataTable(
            showCheckboxColumn: false,
            columnSpacing: 20,
            onSelectAll: (_) {},
            columns: const <DataColumn>[
              DataColumn(label: Text('Title'), numeric: false),
              DataColumn(label: Text('Average Power'), numeric: false),
              DataColumn(label: Text('Watts'), numeric: true),
              DataColumn(label: Text('Power Zone Distribution'), numeric: false),
              DataColumn(label: Text('Average Heart Rate'), numeric: false),
              DataColumn(label: Text('bpm'), numeric: true),
              DataColumn(label: Text('Heart Rate Zone Distribution'), numeric: false),
              DataColumn(label: Text('Average Pace'), numeric: false),
              DataColumn(label: Text('min/km'), numeric: true),
            ],
            rows: <DataRow>[
              DataRow(cells: <DataCell>[
                const DataCell(Text('Activity')),
                DataCell(
                  MyBarChart(
                    value: widget.activity.db.avgPower,
                    powerZones: _powerZones,
                  ),
                ),
                DataCell(
                  Text(widget.activity.db.avgPower.toStringAsFixed(1)),
                ),
                DataCell(
                  MyBarChart.visualizeDistributions(distributions: _heartRateDistributions),
                ),
                DataCell(
                  MyBarChart(
                    value: widget.activity.db.avgHeartRate,
                    heartRateZones: _heartRateZones,
                  ),
                ),
                DataCell(Text(
                  widget.activity.db.avgHeartRate.toString(),
                )),
                DataCell(
                  MyBarChart.visualizeDistributions(distributions: _powerDistributions),
                ),
                DataCell(MyBarChart(
                  value: widget.activity.db.avgSpeed.toPaceDouble(),
                  maximum: 700,
                )),
                DataCell(Text(
                  widget.activity.db.avgSpeed.toPace(),
                )),
              ]),
              for (Lap lap in _laps)
                DataRow(cells: <DataCell>[
                  DataCell(Text('Lap ' + lap.index.toString())),
                  DataCell(
                    MyBarChart(
                      value: lap.db.avgPower,
                      powerZones: _powerZones,
                    ),
                  ),
                  DataCell(
                    Text(lap.db.avgPower.toStringAsFixed(1)),
                  ),
                  DataCell(
                    MyBarChart.visualizeDistributions(distributions: lap.powerDistributions),
                  ),
                  DataCell(
                    MyBarChart(
                      value: lap.db.avgHeartRate,
                      heartRateZones: _heartRateZones,
                    ),
                  ),
                  DataCell(
                    Text(lap.db.avgHeartRate.toString()),
                  ),
                  DataCell(
                    MyBarChart.visualizeDistributions(distributions: lap.heartRateDistributions),
                  ),
                  DataCell(MyBarChart(
                    value: lap.db.avgSpeed.toPaceDouble(),
                    maximum: 700,
                  )),
                  DataCell(Text(
                    lap.db.avgSpeed.toPace(),
                  )),
                ]),
            ]),
      );
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    _laps = await activity.laps;
    for(final Lap _lap in _laps) {
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
