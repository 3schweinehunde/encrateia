import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_power_ratio_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityPowerRatioWidget extends StatefulWidget {
  const ActivityPowerRatioWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityPowerRatioWidgetState createState() =>
      _ActivityPowerRatioWidgetState();
}

class _ActivityPowerRatioWidgetState extends State<ActivityPowerRatioWidget> {
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
          .where((Event value) =>
              value.power != null &&
              value.power > 100 &&
              value.formPower != null &&
              value.formPower > 0 &&
              value.formPower < 200)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityPowerRatioChart(
                  records: RecordList<Event>(powerRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                ),
              ),
              const Text('power ratio (%) = (power - form power) / power * 100'),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 100 W and 0 W < form power < 200 W are shown.'),
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
                leading: MyIcon.formPower,
                title: PQText(value: widget.activity.avgPowerRatio, pq: PQ.percentage,),
                subtitle: const Text('average power ratio'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.activity.sdevPowerRatio, pq: PQ.percentage,),
                subtitle: const Text('standard deviation power ratio '),
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
          child: Text('No power ratio data available.'),
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
