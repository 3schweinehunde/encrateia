import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/widgets/charts/lap_charts/lap_leg_spring_stiffness_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class IntervalLegSpringStiffnessWidget extends StatefulWidget {
  const IntervalLegSpringStiffnessWidget({this.interval});

  final encrateia.Interval interval;

  @override
  _IntervalLegSpringStiffnessWidgetState createState() =>
      _IntervalLegSpringStiffnessWidgetState();
}

class _IntervalLegSpringStiffnessWidgetState
    extends State<IntervalLegSpringStiffnessWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalLegSpringStiffnessWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> legSpringStiffnessRecords = records
          .where((Event value) =>
      value.legSpringStiffness != null && value.legSpringStiffness > 0)
          .toList();

      if (legSpringStiffnessRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapLegSpringStiffnessChart(
                records: RecordList<Event>(legSpringStiffnessRecords),
                minimum: widget.interval.avgLegSpringStiffness / 1.20,
                maximum: widget.interval.avgLegSpringStiffness * 1.20,
              ),
              const Text('Only records where leg spring stiffness > 0 kN/m '
                  'are shown.'),
              const Text('Swipe left/write to compare with other intervals.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.interval.avgLegSpringStiffness,
                  pq: PQ.legSpringStiffness,
                ),
                subtitle: const Text('average leg spring stiffness'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.interval.sdevLegSpringStiffness,
                  pq: PQ.legSpringStiffness,
                ),
                subtitle: const Text('standard leg spring stiffness'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(
                  value: legSpringStiffnessRecords.length,
                  pq: PQ.integer,
                ),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No leg spring stiffness data available.'),
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
