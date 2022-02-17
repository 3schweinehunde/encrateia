import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/power_zone.dart';
import '/models/power_zone_schema.dart';
import '/models/record_list.dart';
import '/utils/PQText.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/activity_charts/activity_power_chart.dart';

class ActivityPowerWidget extends StatefulWidget {
  const ActivityPowerWidget({
    required this.activity,
    required this.athlete,
  });

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityPowerWidgetState createState() => _ActivityPowerWidgetState();
}

class _ActivityPowerWidgetState extends State<ActivityPowerWidget> {
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
  Widget build(BuildContext context) {
    if (records.isNotEmpty && powerZones != null) {
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power! > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        final Event lastRecord = powerRecords.last;
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityPowerChart(
                  records: RecordList<Event>(powerRecords),
                  activity: widget.activity,
                  powerZones: powerZones,
                  athlete: widget.athlete,
                ),
              ),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 100 W are shown.'),
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
                title: PQText(value: widget.activity!.avgPower, pq: PQ.power),
                subtitle: const Text('average power'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(value: widget.activity!.minPower, pq: PQ.power),
                subtitle: const Text('minimum power'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(value: widget.activity!.maxPower, pq: PQ.power),
                subtitle: const Text('maximum power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.activity!.sdevPower, pq: PQ.power),
                subtitle: const Text('standard deviation power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: powerRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
              ListTile(
                leading: const Text('🕵️‍♀️', style: TextStyle(fontSize: 25)),
                title: Row(
                  children: <Widget>[
                    PQText(value: lastRecord.positionLong, pq: PQ.longitude),
                    const Text(' / '),
                    PQText(value: lastRecord.positionLat, pq: PQ.latitude),
                  ],
                ),
                subtitle: const Text('findYourStryd (last power record)'),
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
    final Activity activity = widget.activity!;
    records = RecordList<Event>(await activity.records);

    powerZoneSchema = await activity.powerZoneSchema;
    if (powerZoneSchema != null) {
      powerZones = await powerZoneSchema!.powerZones;
    } else {
      powerZones = <PowerZone>[];
    }
    setState(() => loading = false);
  }
}
