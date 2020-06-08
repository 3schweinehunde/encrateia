import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_ground_time_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityGroundTimeWidget extends StatefulWidget {
  const ActivityGroundTimeWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityGroundTimeWidgetState createState() =>
      _ActivityGroundTimeWidgetState();
}

class _ActivityGroundTimeWidgetState extends State<ActivityGroundTimeWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgGroundTimeString = 'Loading ...';
  String sdevGroundTimeString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> groundTimeRecords = records
          .where((Event value) =>
              value.groundTime != null && value.groundTime > 0)
          .toList();

      if (groundTimeRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityGroundTimeChart(
                records: RecordList<Event>(groundTimeRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'ground time > 0 ms are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgGroundTimeString),
                subtitle: const Text('average ground time'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevGroundTimeString),
                subtitle: const Text('standard deviation ground time'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(groundTimeRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No ground time data available.'),
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
    avgGroundTimeString = activity.db.avgGroundTime != null
        ? activity.db.avgGroundTime.toStringOrDashes(1) + ' ms'
        : '- - -';
    sdevGroundTimeString =
        activity.db.sdevGroundTime.toStringOrDashes(2) + ' ms';
    setState(() {});
  }
}
