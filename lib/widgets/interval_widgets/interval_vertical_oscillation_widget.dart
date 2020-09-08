import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/widgets/charts/lap_charts/lap_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class IntervalVerticalOscillationWidget extends StatefulWidget {
  const IntervalVerticalOscillationWidget({this.interval});

  final encrateia.Interval interval;

  @override
  _IntervalVerticalOscillationWidgetState createState() =>
      _IntervalVerticalOscillationWidgetState();
}

class _IntervalVerticalOscillationWidgetState
    extends State<IntervalVerticalOscillationWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalVerticalOscillationWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> verticalOscillationRecords = records
          .where((Event value) =>
      value.verticalOscillation != null &&
          value.verticalOscillation > 0)
          .toList();

      if (verticalOscillationRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapVerticalOscillationChart(
                records: RecordList<Event>(verticalOscillationRecords),
                minimum: widget.interval.avgVerticalOscillation / 1.25,
                maximum: widget.interval.avgVerticalOscillation * 1.25,
              ),
              const Text(
                  'Only records where vertical oscillation is present are shown.'),
              const Text('Swipe left/write to compare with other intervals.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.interval.avgVerticalOscillation,
                  pq: PQ.verticalOscillation,
                ),
                subtitle: const Text('average vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.interval.sdevVerticalOscillation,
                  pq: PQ.verticalOscillation,
                ),
                subtitle: const Text('standard deviation vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(
                  value: verticalOscillationRecords.length,
                  pq: PQ.integer,
                ),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No vertical oscillation data available.'),
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
