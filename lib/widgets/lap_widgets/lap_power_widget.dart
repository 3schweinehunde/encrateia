import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapPowerWidget extends StatefulWidget {
  const LapPowerWidget({this.lap});

  final Lap lap;

  @override
  _LapPowerWidgetState createState() => _LapPowerWidgetState();
}

class _LapPowerWidgetState extends State<LapPowerWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgPowerString = 'Loading ...';
  String minPowerString = 'Loading ...';
  String maxPowerString = 'Loading ...';
  String sdevPowerString = 'Loading ...';
  PowerZoneSchema powerZoneSchema;
  List<PowerZone> powerZones;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapPowerWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapPowerChart(
                records: RecordList<Event>(powerRecords),
                powerZones: powerZones,
              ),
              const Text('Only records where power > 100 W are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgPowerString),
                subtitle: const Text('average power'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(minPowerString),
                subtitle: const Text('minimum power'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(maxPowerString),
                subtitle: const Text('maximum power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevPowerString),
                subtitle: const Text('standard deviation power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(powerRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No power data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Lap lap = widget.lap;
    records = RecordList<Event>(await lap.records);

    avgPowerString = lap.avgPower.toStringOrDashes(1) + ' W';
    minPowerString = lap.minPower.toString() + ' W';
    maxPowerString = lap.maxPower.toString() + ' W';
    sdevPowerString = lap.sdevPower.toStringOrDashes(2) + ' W';

    powerZoneSchema = await lap.powerZoneSchema;
    if (powerZoneSchema != null)
      powerZones = await powerZoneSchema.powerZones;
    else
      powerZones = <PowerZone>[];
    setState(() {});
  }
}
