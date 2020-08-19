import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/event.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/widgets/charts/power_duration_chart.dart';

class LapPowerDurationWidget extends StatefulWidget {
  const LapPowerDurationWidget({@required this.lap});

  final Lap lap;

  @override
  _LapPowerDurationWidgetState createState() => _LapPowerDurationWidgetState();
}

class _LapPowerDurationWidgetState extends State<LapPowerDurationWidget> {
  List<Event> records = <Event>[];
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapPowerDurationWidget oldWidget) {
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
            const Text('Swipe left/write to compare with other laps.'),
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
    records = RecordList<Event>(await widget.lap.records);
    setState(() => loading = false);
  }
}
