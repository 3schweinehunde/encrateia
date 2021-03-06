import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_heart_rate_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityHeartRateWidget extends StatefulWidget {
  const ActivityHeartRateWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityHeartRateWidgetState createState() =>
      _ActivityHeartRateWidgetState();
}

class _ActivityHeartRateWidgetState extends State<ActivityHeartRateWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  HeartRateZoneSchema heartRateZoneSchema;
  List<HeartRateZone> heartRateZones;
  bool loading = true;
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> heartRateRecords = records
          .where(
              (Event value) => value.heartRate != null && value.heartRate > 10)
          .toList();

      if (heartRateRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityHeartRateChart(
                  records: RecordList<Event>(heartRateRecords),
                  activity: widget.activity,
                  heartRateZones: heartRateZones,
                  athlete: widget.athlete,
                ),
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'heart rate > 10 bpm are shown.'),
              Row(children: <Widget>[
                const Spacer(),
                MyButton.save(
                  child: Text(screenShotButtonText),
                  onPressed: () async {
                    await ImageUtils.capturePng(widgetKey: widgetKey);
                    screenShotButtonText = 'Image saved';
                    setState(() {});
                  },
                ),
                const SizedBox(width: 20),
              ]),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.activity.avgHeartRate,
                  pq: PQ.heartRate,
                ),
                subtitle: const Text('average heart rate'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(
                  value: widget.activity.minHeartRate,
                  pq: PQ.heartRate,
                ),
                subtitle: const Text('minimum heart rate'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(
                  value: widget.activity.maxHeartRate,
                  pq: PQ.heartRate,
                ),
                subtitle: const Text('maximum heart rate'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.activity.sdevHeartRate,
                  pq: PQ.heartRate,
                ),
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
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);

    heartRateZoneSchema = await activity.heartRateZoneSchema;
    if (heartRateZoneSchema != null)
      heartRateZones = await heartRateZoneSchema.heartRateZones;
    else
      heartRateZones = <HeartRateZone>[];
    setState(() => loading = false);
  }
}
