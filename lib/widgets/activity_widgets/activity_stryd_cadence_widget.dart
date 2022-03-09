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
import '/widgets/charts/activity_charts/activity_stryd_cadence_chart.dart';

class ActivityStrydCadenceWidget extends StatefulWidget {
  const ActivityStrydCadenceWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityStrydCadenceWidgetState createState() =>
      _ActivityStrydCadenceWidgetState();
}

class _ActivityStrydCadenceWidgetState
    extends State<ActivityStrydCadenceWidget> {
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
              value.strydCadence != null && value.strydCadence! > 0)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivityStrydCadenceChart(
                  records: RecordList<Event>(powerRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                  minimum: widget.activity!.avgStrydCadence! * 2 / 1.25,
                  maximum: widget.activity!.avgStrydCadence! * 2 * 1.25,
                ),
              ),
              Text('${widget.athlete!.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'cadence > 0 s/min are shown.'),
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
                  value: widget.activity!.avgStrydCadence,
                  pq: PQ.cadence,
                ),
                subtitle: const Text('average cadence'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.activity!.sdevStrydCadence,
                  pq: PQ.cadence,
                ),
                subtitle: const Text('standard deviation cadence'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(powerRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No cadence data available.'),
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
