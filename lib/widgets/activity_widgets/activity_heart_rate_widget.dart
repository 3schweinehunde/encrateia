import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/record_list.dart';
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

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> heartRateRecords = records
          .where((Event value) =>
              value.heartRate != null && value.heartRate > 10)
          .toList();

      if (heartRateRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityHeartRateChart(
                records: RecordList<Event>(heartRateRecords),
                activity: widget.activity,
                heartRateZones: heartRateZones,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'heart rate > 10 bpm are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(widget.activity.avgHeartRate.toString()),
                subtitle: const Text('average heart rate'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(records.minHeartRateString),
                subtitle: const Text('minimum heart rate'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(widget.activity.maxHeartRate.toString()),
                subtitle: const Text('maximum heart rate'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(records.sdevHeartRateString),
                subtitle: const Text('standard deviation heart rate'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(heartRateRecords.length.toString()),
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
      return const Center(
        child: Text('Loading'),
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
    setState(() {});
  }
}
