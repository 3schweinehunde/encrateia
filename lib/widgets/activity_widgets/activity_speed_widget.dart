import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_speed_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivitySpeedWidget extends StatefulWidget {
  const ActivitySpeedWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivitySpeedWidgetState createState() => _ActivitySpeedWidgetState();
}

class _ActivitySpeedWidgetState extends State<ActivitySpeedWidget> {
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
          .where((Event value) => value.speed != null && value.speed > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: ActivitySpeedChart(
                  records: RecordList<Event>(paceRecords),
                  activity: widget.activity,
                  athlete: widget.athlete,
                  minimum:
                      (widget.activity.avgSpeed - 3 * widget.activity.sdevSpeed) *
                          3.6,
                  maximum:
                      (widget.activity.avgSpeed + 3 * widget.activity.sdevSpeed) *
                          3.6,
                ),
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'speed > 0 m/s are shown.'),
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
                title: PQText(value: widget.activity.avgSpeed, pq: PQ.speed),
                subtitle: const Text('average speed (as in .fit-file)'),
              ),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.activity.avgSpeedByMeasurements,
                  pq: PQ.speed,
                ),
                subtitle: const Text('mean speed'),
              ),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.activity.avgSpeedBySpeed,
                  pq: PQ.speed,
                ),
                subtitle: const Text('mean speed (time weighted)'),
              ),
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.activity.avgSpeedByDistance,
                  pq: PQ.speed,
                ),
                subtitle:
                    const Text('average speed (calculated)'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.activity.sdevSpeed, pq: PQ.speed),
                subtitle: const Text('standard deviation speed'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(value: widget.activity.minSpeed, pq: PQ.speed),
                subtitle: const Text('minimum speed'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(value: widget.activity.maxSpeed, pq: PQ.speed),
                subtitle: const Text('maximum speed'),
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
          child: Text('No speed data available.'),
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
