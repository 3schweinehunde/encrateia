import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/models/weight.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/utils/pg_text.dart';
import '/widgets/charts/activity_charts/activity_ecor_chart.dart';

class ActivityEcorWidget extends StatefulWidget {
  const ActivityEcorWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  ActivityEcorWidgetState createState() => ActivityEcorWidgetState();
}

class ActivityEcorWidgetState extends State<ActivityEcorWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  Weight? weight;
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
      final List<Event> ecorRecords = records
          .where((Event value) =>
              value.power != null &&
              value.power! > 100 &&
              value.speed != null &&
              value.speed! >= 1)
          .toList();

      if (ecorRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityEcorChart(
                  records: RecordList<Event>(ecorRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                  weight: widget.activity!.cachedWeight,
                ),
              ),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 0 W and speed > 1 m/s are shown.'),
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
                leading: MyIcon.power,
                title: PQText(value: widget.activity!.cachedEcor, pq: PQ.ecor),
                subtitle: const Text('ecor (Energy cost of running)'),
              ),
              ListTile(
                leading: MyIcon.weight,
                title:
                    PQText(value: widget.activity!.cachedWeight, pq: PQ.weight),
                subtitle: const Text('weight'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: ecorRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No ecor data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity!.records);
    await widget.activity!.ecor;
    setState(() => loading = false);
  }
}
