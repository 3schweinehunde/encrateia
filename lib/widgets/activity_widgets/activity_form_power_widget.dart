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
import '/widgets/charts/activity_charts/activity_form_power_chart.dart';

class ActivityFormPowerWidget extends StatefulWidget {
  const ActivityFormPowerWidget({
    required this.activity,
    required this.athlete,
  });

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityFormPowerWidgetState createState() =>
      _ActivityFormPowerWidgetState();
}

class _ActivityFormPowerWidgetState extends State<ActivityFormPowerWidget> {
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
    final Activity? activity = widget.activity;

    if (records.isNotEmpty) {
      final List<Event> formPowerRecords = records
          .where((Event value) =>
              value.formPower != null &&
              value.formPower! > 0 &&
              value.formPower! < 200)
          .toList();

      if (formPowerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityFormPowerChart(
                  records: RecordList<Event>(formPowerRecords),
                  activity: activity,
                  athlete: widget.athlete,
                  minimum: activity!.avgFormPower! / 1.25,
                  maximum: activity.avgFormPower! * 1.25,
                ),
              ),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  '0 W < form power < 200 W are shown.'),
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
                leading: MyIcon.formPower,
                title: PQText(value: activity.avgFormPower, pq: PQ.power),
                subtitle: const Text('average form power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: activity.sdevFormPower, pq: PQ.power),
                subtitle: const Text('standard deviation form power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: formPowerRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No form power data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity!.records);
    setState(() => loading = false);
  }
}
