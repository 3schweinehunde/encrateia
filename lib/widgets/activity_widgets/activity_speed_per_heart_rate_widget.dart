import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/activity_charts/activity_speed_per_heart_rate_chart.dart';

class ActivitySpeedPerHeartRateWidget extends StatefulWidget {
  const ActivitySpeedPerHeartRateWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  ActivitySpeedPerHeartRateWidgetState createState() =>
      ActivitySpeedPerHeartRateWidgetState();
}

class ActivitySpeedPerHeartRateWidgetState
    extends State<ActivitySpeedPerHeartRateWidget> {
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
      final List<Event> speedPerHeartRateRecords = records
          .where((Event value) =>
              value.speed != null &&
              value.heartRate != null &&
              value.heartRate! > 0)
          .toList();

      if (speedPerHeartRateRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivitySpeedPerHeartRateChart(
                  records: RecordList<Event>(speedPerHeartRateRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                ),
              ),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'speed is present and heart rate > 0 bpm are shown.'),
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
                  value: widget.activity!.avgSpeedPerHeartRate,
                  pq: PQ.speedPerHeartRate,
                ),
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
