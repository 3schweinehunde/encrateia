import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_leg_spring_stiffness_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityLegSpringStiffnessWidget extends StatefulWidget {
  const ActivityLegSpringStiffnessWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityLegSpringStiffnessWidgetState createState() =>
      _ActivityLegSpringStiffnessWidgetState();
}

class _ActivityLegSpringStiffnessWidgetState
    extends State<ActivityLegSpringStiffnessWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgLegSpringStiffnessString = 'Loading ...';
  String sdevLegSpringStiffnessString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> legSpringStiffnessRecords = records
          .where((Event value) =>
              value.db.legSpringStiffness != null &&
              value.db.legSpringStiffness > 0)
          .toList();

      if (legSpringStiffnessRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityLegSpringStiffnessChart(
                records: RecordList<Event>(legSpringStiffnessRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'leg spring stiffness > 0 kN/m are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgLegSpringStiffnessString),
                subtitle: const Text('average leg spring stiffness'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevLegSpringStiffnessString),
                subtitle: const Text('standard deviation leg spring stiffness'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(records.length.toString()),
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
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    avgLegSpringStiffnessString =
        activity.db.avgLegSpringStiffness.toStringOrDashes(1) + ' ms';

    sdevLegSpringStiffnessString =
        activity.db.sdevLegSpringStiffness.toStringOrDashes(2) + ' ms';
    setState(() {});
  }
}
