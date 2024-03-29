import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/my_color.dart';
import '/widgets/charts/activity_charts/activity_intervals_chart.dart';

class SelectIntervalScreen extends StatefulWidget {
  const SelectIntervalScreen({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  SelectIntervalScreenState createState() => SelectIntervalScreenState();
}

class SelectIntervalScreenState extends State<SelectIntervalScreen> {
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
          .where((Event value) => value.speed != null && value.speed! > 0)
          .toList();

      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.settings,
          title: const Text('Specify Interval'),
        ),
        body: SafeArea(
          child: ActivityIntervalsChart(
            records: RecordList<Event>(paceRecords),
            activity: widget.activity,
            athlete: widget.athlete,
            minimum: widget.activity!.avgSpeed! * 3.6 / 2,
            maximum: widget.activity!.avgSpeed! * 3.6 * 2,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.settings,
          title: const Text('Specify Interval'),
        ),
        body: const Text('Loading...'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity!.records);
    setState(() {});
  }
}
