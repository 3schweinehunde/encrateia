import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_ecor_chart.dart';
import 'package:flutter/material.dart';

class ActivityEcorWidget extends StatefulWidget {
  const ActivityEcorWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityEcorWidgetState createState() => _ActivityEcorWidgetState();
}

class _ActivityEcorWidgetState extends State<ActivityEcorWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  Weight weight;
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
              value.power > 100 &&
              value.speed != null &&
              value.speed >= 1)
          .toList();

      if (ecorRecords.isNotEmpty && ecorRecords != null) {
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
                  weight: widget.activity.cachedWeight,
                ),
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 0 W and speed > 1 m/s are shown.'),
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
                leading: MyIcon.power,
                title: PQText(value: widget.activity.cachedEcor, pq: PQ.ecor),
                subtitle: const Text('ecor (Energy cost of running)'),
              ),
              ListTile(
                leading: MyIcon.weight,
                title:
                    PQText(value: widget.activity.cachedWeight, pq: PQ.weight),
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
    records = RecordList<Event>(await widget.activity.records);
    await widget.activity.ecor;
    setState(() => loading = false);
  }
}
