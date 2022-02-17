import 'package:flutter/material.dart';

import '/models/event.dart';
import '/models/lap.dart';
import '/models/power_zone.dart';
import '/models/power_zone_schema.dart';
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_power_chart.dart';

class LapPowerWidget extends StatefulWidget {
  const LapPowerWidget({this.lap});

  final Lap? lap;

  @override
  _LapPowerWidgetState createState() => _LapPowerWidgetState();
}

class _LapPowerWidgetState extends State<LapPowerWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;
  PowerZoneSchema? powerZoneSchema;
  List<PowerZone>? powerZones;
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

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
          .where((Event value) => value.power != null && value.power! > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapPowerChart(
                  records: RecordList<Event>(powerRecords),
                  powerZones: powerZones,
                ),
              ),
              const Text('Only records where power > 100 W are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              Row(children: <Widget>[
                const Spacer(),
                MyButton.save(
                  child: Text(screenShotButtonText),
                  onPressed: () async {
                    await image_utils.capturePng(widgetKey: widgetKey);
                    screenShotButtonText = 'Image saved';
                    setState(() {});
                  },
                ),
                const SizedBox(width: 20),
              ]),
              ListTile(
                leading: MyIcon.average,
                title: PQText(value: widget.lap!.avgPower, pq: PQ.power),
                subtitle: const Text('average power'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(value: widget.lap!.minPower, pq: PQ.power),
                subtitle: const Text('minimum power'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(value: widget.lap!.maxPower, pq: PQ.power),
                subtitle: const Text('maximum power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.lap!.sdevPower, pq: PQ.power),
                subtitle: const Text('standard deviation power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: powerRecords.length, pq: PQ.integer),
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
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await (widget.lap!.records as Future<List<Event>>));
    powerZoneSchema = await widget.lap!.powerZoneSchema;
    if (powerZoneSchema != null) {
      powerZones = await powerZoneSchema!.powerZones;
    } else {
      powerZones = <PowerZone>[];
    }
    setState(() => loading = false);
  }
}
