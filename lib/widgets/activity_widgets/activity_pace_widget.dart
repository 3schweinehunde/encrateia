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
import '/widgets/charts/activity_charts/activity_pace_chart.dart';

class ActivityPaceWidget extends StatefulWidget {
  const ActivityPaceWidget({Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityPaceWidgetState createState() => _ActivityPaceWidgetState();
}

class _ActivityPaceWidgetState extends State<ActivityPaceWidget> {
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
      final List<Event> paceRecords = records
          .where((Event value) => value.speed != null && value.speed! > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityPaceChart(
                  records: RecordList<Event>(paceRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                  minimum: 50 / 3 / widget.activity!.avgSpeed! -
                      3 * widget.activity!.sdevPace!,
                  maximum: 50 / 3 / widget.activity!.avgSpeed! +
                      3 * widget.activity!.sdevPace!,
                ),
              ),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'speed > 0 m/s are shown.'),
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
                title: PQText(value: widget.activity!.avgPace, pq: PQ.pace),
                subtitle: const Text('average pace'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.activity!.sdevPace, pq: PQ.pace),
                subtitle: const Text('standard deviation pace'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: paceRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No pace data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity!;
    records = RecordList<Event>(await activity.records);
    setState(() => loading = false);
  }
}
