import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/event.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/widgets/charts/power_duration_chart.dart';

class IntervalPowerDurationWidget extends StatefulWidget {
  const IntervalPowerDurationWidget({@required this.interval});

  final encrateia.Interval interval;

  @override
  _IntervalPowerDurationWidgetState createState() => _IntervalPowerDurationWidgetState();
}

class _IntervalPowerDurationWidgetState extends State<IntervalPowerDurationWidget> {
  List<Event> records = <Event>[];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalPowerDurationWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListView(
          padding: const EdgeInsets.only(left: 15),
          children: <Widget>[
            PowerDurationChart(records: powerRecords),
            const Text('Swipe left/write to compare with other intervals.'),
            const Divider(),
          ],
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
    records = RecordList<Event>(await widget.interval.records);
    setState(() => loading = false);
  }
}
