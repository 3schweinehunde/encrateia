import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/PQText.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/activity_charts/activity_ground_time_chart.dart';

class ActivityGroundTimeWidget extends StatefulWidget {
  const ActivityGroundTimeWidget({
    required this.activity,
    required this.athlete,
  });

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityGroundTimeWidgetState createState() =>
      _ActivityGroundTimeWidgetState();
}

class _ActivityGroundTimeWidgetState extends State<ActivityGroundTimeWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> groundTimeRecords = records
          .where(
              (Event value) => value.groundTime != null && value.groundTime! > 0)
          .toList();

      if (groundTimeRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityGroundTimeChart(
                  records: RecordList<Event>(groundTimeRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                  minimum: widget.activity!.avgGroundTime! / 1.5,
                  maximum: widget.activity!.avgGroundTime! * 1.25,
                ),
              ),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'ground time > 0 ms are shown.'),
              Row(children: <Widget>[
                const Spacer(),
                MyButton.save(
                  child: Text(screenShotButtonText),
                  onPressed: () async {
                    await image_utils.capturePng(widgetKey: widgetKey);
                    screenShotButtonText = 'Image saved';
                    setState(() {});
                  },
                ),
                const SizedBox(width: 20),
              ]),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                    value: widget.activity!.avgGroundTime, pq: PQ.groundTime),
                subtitle: const Text('average ground time'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                    value: widget.activity!.sdevGroundTime, pq: PQ.groundTime),
                subtitle: const Text('standard deviation ground time'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: groundTimeRecords.length, pq: PQ.integer),
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
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity!;
    records = RecordList<Event>(await activity.records);
    setState(() => loading = false);
  }
}
