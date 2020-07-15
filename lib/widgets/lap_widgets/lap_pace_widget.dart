import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/event.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_pace_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/date_time_utils.dart';

class LapPaceWidget extends StatefulWidget {
  const LapPaceWidget({this.lap});

  final Lap lap;

  @override
  _LapPaceWidgetState createState() => _LapPaceWidgetState();
}

class _LapPaceWidgetState extends State<LapPaceWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgHeartRateString = 'Loading ...';
  String sdevHeartRateString = 'Loading ...';
  HeartRateZoneSchema heartRateZoneSchema;
  List<HeartRateZone> heartRateZones;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapPaceWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> paceRecords = records
          .where(
              (Event value) => value.speed != null && value.speed > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapPaceChart(
                records: RecordList<Event>(paceRecords),
                minimum: 50 / 3 / widget.lap.avgSpeed / 2,
                maximum: 50 / 3 / widget.lap.avgSpeed * 1.5,
              ),
              const Text('Only records where speed > 0 m/s are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(widget.lap.avgSpeed.toPace()),
                subtitle: const Text('average pace'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(widget.lap.minSpeed.toPace()),
                subtitle: const Text('minimum pace'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(widget.lap.maxSpeed.toPace()),
                subtitle: const Text('maximum pace'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(widget.lap.sdevPace.toStringAsFixed(2) + ' s'),
                subtitle: const Text('standard deviation pace'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(paceRecords.length.toString()),
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
    final Lap lap = widget.lap;
    records = RecordList<Event>(await lap.records);
    setState(() {});
  }
}
