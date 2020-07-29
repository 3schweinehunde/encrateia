import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_intervals_chart.dart';

class ActivityIntervalsWidget extends StatefulWidget {
  const ActivityIntervalsWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityIntervalsWidgetState createState() =>
      _ActivityIntervalsWidgetState();
}

class _ActivityIntervalsWidgetState extends State<ActivityIntervalsWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> paceRecords = records
          .where((Event value) => value.speed != null && value.speed > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ActivityIntervalsChart(
          records: RecordList<Event>(paceRecords),
          activity: widget.activity,
          athlete: widget.athlete,
          minimum: widget.activity.avgSpeed * 3.6 / 1.5,
          maximum: widget.activity.avgSpeed * 3.6 * 1.5,
        );
      } else {
        return const Center(
          child: Text('No speed data available.'),
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
    setState(() {});
  }
}
