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
import '/widgets/charts/activity_charts/activity_vertical_oscillation_chart.dart';

class ActivityVerticalOscillationWidget extends StatefulWidget {
  const ActivityVerticalOscillationWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityVerticalOscillationWidgetState createState() =>
      _ActivityVerticalOscillationWidgetState();
}

class _ActivityVerticalOscillationWidgetState
    extends State<ActivityVerticalOscillationWidget> {
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
      final List<Event> powerRecords = records
          .where((Event value) => value.verticalOscillation != null)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityVerticalOscillationChart(
                  records: RecordList<Event>(powerRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                  minimum: widget.activity.avgVerticalOscillation / 1.25,
                  maximum: widget.activity.avgVerticalOscillation * 1.25,
                ),
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'vertical oscillation is present are shown.'),
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
                  value: widget.activity.avgVerticalOscillation,
                  pq: PQ.verticalOscillation,
                ),
                subtitle: const Text('average vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.activity.sdevVerticalOscillation,
                  pq: PQ.verticalOscillation,
                ),
                subtitle: const Text('standard deviation vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: powerRecords.length, pq: PQ.integer),
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
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    setState(() => loading = false);
  }
}
