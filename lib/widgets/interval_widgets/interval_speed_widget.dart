import 'package:flutter/material.dart';

import '/models/event.dart';
import '/models/interval.dart' as encrateia;
import '/models/record_list.dart';
import '/utils/PQText.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_speed_chart.dart';

class IntervalSpeedWidget extends StatefulWidget {
  const IntervalSpeedWidget({this.interval});

  final encrateia.Interval? interval;

  @override
  _IntervalSpeedWidgetState createState() => _IntervalSpeedWidgetState();
}

class _IntervalSpeedWidgetState extends State<IntervalSpeedWidget> {
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
  void didUpdateWidget(IntervalSpeedWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> paceRecords = records
          .where((Event value) => value.speed != null && value.speed! > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapSpeedChart(
                  records: RecordList<Event>(paceRecords),
                  minimum: (widget.interval!.avgSpeedByDistance! -
                          3 * widget.interval!.sdevSpeed!) *
                      3.6,
                  maximum: (widget.interval!.avgSpeedByDistance! +
                          3 * widget.interval!.sdevSpeed!) *
                      3.6,
                ),
              ),
              const Text('Only records where speed > 0 m/s are shown.'),
              const Text('Swipe left/write to compare with other intervals.'),
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
                    value: widget.interval!.avgSpeedByDistance, pq: PQ.speed),
                subtitle: const Text('average speed'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: PQText(value: widget.interval!.minSpeed, pq: PQ.speed),
                subtitle: const Text('minimum speed'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: PQText(value: widget.interval!.maxSpeed, pq: PQ.speed),
                subtitle: const Text('maximum speed'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.interval!.sdevSpeed, pq: PQ.speed),
                subtitle: const Text('standard deviation speed'),
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
          child: Text('No heart rate data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.interval!.records);
    setState(() => loading = false);
  }
}
