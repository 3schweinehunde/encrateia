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
import '/widgets/charts/activity_charts/activity_stride_ratio_chart.dart';

class ActivityStrideRatioWidget extends StatefulWidget {
  const ActivityStrideRatioWidget({Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityStrideRatioWidgetState createState() =>
      _ActivityStrideRatioWidgetState();
}

class _ActivityStrideRatioWidgetState extends State<ActivityStrideRatioWidget> {
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
      final List<Event> strideRatioRecords = records
          .where((Event value) =>
              value.speed != null &&
              value.strydCadence != null &&
              value.verticalOscillation != null &&
              value.verticalOscillation != 0)
          .toList();

      if (strideRatioRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityStrideRatioChart(
                  records: RecordList<Event>(strideRatioRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                ),
              ),
              const Text(
                  'stride ratio = stride length (cm) / vertical oscillation'
                  ' (cm)'),
              const Text(
                  'stride length (cm) = 10 000 / 6 * speed (km/h) / cadence '
                  '(strides/min)'),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'cadence is present and vertical oscillation > 0 mm are shown.'),
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
                leading: MyIcon.strideRatio,
                title: PQText(
                    value: widget.activity!.avgStrideRatio, pq: PQ.double),
                subtitle: const Text('average stride ratio'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                    value: widget.activity!.sdevStrideRatio, pq: PQ.double),
                subtitle: const Text('standard deviation stride ratio '),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: strideRatioRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No stride ratio data available.'),
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
