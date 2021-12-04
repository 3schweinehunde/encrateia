import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_power_per_heart_rate_chart.dart';
import 'package:flutter/material.dart';

class ActivityPowerPerHeartRateWidget extends StatefulWidget {
  const ActivityPowerPerHeartRateWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityPowerPerHeartRateWidgetState createState() =>
      _ActivityPowerPerHeartRateWidgetState();
}

class _ActivityPowerPerHeartRateWidgetState
    extends State<ActivityPowerPerHeartRateWidget> {
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
      final List<Event> powerPerHeartRateRecords = records
          .where((Event value) =>
              value.power != null &&
              value.power > 100 &&
              value.heartRate != null &&
              value.heartRate > 0)
          .toList();

      if (powerPerHeartRateRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityPowerPerHeartRateChart(
                  records: RecordList<Event>(powerPerHeartRateRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                ),
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 100 W and heart rate > 0 bpm are shown.'),
              Row(children: <Widget>[
                const Spacer(),
                MyButton.save(
                  child: Text(screenShotButtonText),
                  onPressed: () async {
                    await ImageUtils.capturePng(widgetKey: widgetKey);
                    screenShotButtonText = 'Image saved';
                    setState(() {});
                  },
                ),
                const SizedBox(width: 20),
              ]),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.activity.avgPowerPerHeartRate,
                  pq: PQ.powerPerHeartRate,
                ),
                subtitle: const Text('average power per heart rate'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No power per heart rate data available.'),
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
