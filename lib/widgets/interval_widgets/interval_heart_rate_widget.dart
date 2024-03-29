import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/heart_rate_zone.dart';
import '/models/heart_rate_zone_schema.dart';
import '/models/interval.dart' as encrateia;
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_heart_rate_chart.dart';

class IntervalHeartRateWidget extends StatefulWidget {
  const IntervalHeartRateWidget({Key? key, this.interval}) : super(key: key);

  final encrateia.Interval? interval;

  @override
  IntervalHeartRateWidgetState createState() => IntervalHeartRateWidgetState();
}

class IntervalHeartRateWidgetState extends State<IntervalHeartRateWidget> {
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
  void didUpdateWidget(IntervalHeartRateWidget oldWidget) {
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
              const Text('Swipe left/write to compare with other intervals.'),
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
                title: PQText(
                    value: widget.interval!.avgHeartRate, pq: PQ.heartRate),
                subtitle: const Text('average heart rate'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(
                    value: widget.interval!.minHeartRate, pq: PQ.heartRate),
                subtitle: const Text('minimum heart rate'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(
                    value: widget.interval!.maxHeartRate, pq: PQ.heartRate),
                subtitle: const Text('maximum heart rate'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                    value: widget.interval!.sdevHeartRate, pq: PQ.heartRate),
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
    records = RecordList<Event>(await widget.interval!.records);
    heartRateZoneSchema = await widget.interval!.heartRateZoneSchema;
    if (heartRateZoneSchema != null) {
      heartRateZones = await heartRateZoneSchema!.heartRateZones;
    } else {
      heartRateZones = <HeartRateZone>[];
    }
    setState(() => loading = false);
  }
}
