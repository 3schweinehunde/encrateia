import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_speed_per_heart_rate_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivitySpeedPerHeartRateWidget extends StatefulWidget {
  const ActivitySpeedPerHeartRateWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivitySpeedPerHeartRateWidgetState createState() =>
      _ActivitySpeedPerHeartRateWidgetState();
}

class _ActivitySpeedPerHeartRateWidgetState
    extends State<ActivitySpeedPerHeartRateWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgSpeedPerHeartRateString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> speedPerHeartRateRecords = records
          .where((Event value) =>
              value.db.speed != null &&
              value.db.heartRate != null &&
              value.db.heartRate > 0)
          .toList();

      if (speedPerHeartRateRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivitySpeedPerHeartRateChart(
                records: RecordList<Event>(speedPerHeartRateRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'speed is present and heart rate > 0 bpm are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgSpeedPerHeartRateString),
                subtitle: const Text('average speed per heart rate'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No speed per heart rate data available.'),
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

    final double avg = 1000 * activity.db.avgSpeed / activity.db.avgHeartRate;
    avgSpeedPerHeartRateString = avg.toStringOrDashes(1) + ' m/h / bpm';
    setState(() {});
  }
}
