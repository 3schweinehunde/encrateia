import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/power_duration_chart.dart';

class ActivityPowerDurationWidget extends StatefulWidget {
  const ActivityPowerDurationWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityPowerDurationWidgetState createState() =>
      _ActivityPowerDurationWidgetState();
}

class _ActivityPowerDurationWidgetState
    extends State<ActivityPowerDurationWidget> {
  bool loading = true;
  RecordList<Event> records = RecordList<Event>(<Event>[]);

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        return SingleChildScrollView(
          child: PowerDurationChart(records: powerRecords),
        );
      } else {
        return const Center(
          child: Text('No power data available.'),
        );
      }
    } else {
      return Container(
        height: 100,
        child: Center(
          child: Text(loading ? 'Loading' : 'No data available'),
        ),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity.records);
    setState(() => loading = false);
  }
}
