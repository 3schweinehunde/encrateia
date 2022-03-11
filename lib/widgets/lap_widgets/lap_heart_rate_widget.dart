import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/heart_rate_zone.dart';
import '/models/heart_rate_zone_schema.dart';
import '/models/lap.dart';
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_heart_rate_chart.dart';

class LapHeartRateWidget extends StatefulWidget {
  const LapHeartRateWidget({Key? key, this.lap}) : super(key: key);

  final Lap? lap;

  @override
  _LapHeartRateWidgetState createState() => _LapHeartRateWidgetState();
}

class _LapHeartRateWidgetState extends State<LapHeartRateWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;
  HeartRateZoneSchema? heartRateZoneSchema;
  List<HeartRateZone>? heartRateZones;
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapHeartRateWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> heartRateRecords = records
          .where(
              (Event value) => value.heartRate != null && value.heartRate! > 0)
          .toList();

      if (heartRateRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapHeartRateChart(
                  records: RecordList<Event>(heartRateRecords),
                  heartRateZones: heartRateZones,
                ),
              ),
              const Text('Only records where heart rate > 10 bpm are shown.'),
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
                title: PQText(value: widget.lap!.avgHeartRate, pq: PQ.heartRate),
                subtitle: const Text('average heart rate'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(value: widget.lap!.minHeartRate, pq: PQ.heartRate),
                subtitle: const Text('minimum heart rate'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(value: widget.lap!.maxHeartRate, pq: PQ.heartRate),
                subtitle: const Text('maximum heart rate'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title:
                    PQText(value: widget.lap!.sdevHeartRate, pq: PQ.heartRate),
                subtitle: const Text('standard deviation heart rate'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: heartRateRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No heart rate data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.lap!.records);
    heartRateZoneSchema = await widget.lap!.heartRateZoneSchema;
    if (heartRateZoneSchema != null) {
      heartRateZones = await heartRateZoneSchema!.heartRateZones;
    } else {
      heartRateZones = <HeartRateZone>[];
    }
    setState(() => loading = false);
  }
}
