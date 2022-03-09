import 'dart:math';
import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/interval.dart' as encrateia;
import '/models/record_list.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/utils/pg_text.dart';
import '/widgets/charts/lap_charts/lap_altitude_chart.dart';

class IntervalAltitudeWidget extends StatefulWidget {
  const IntervalAltitudeWidget({Key? key, this.interval}) : super(key: key);

  final encrateia.Interval? interval;

  @override
  _IntervalAltitudeWidgetState createState() => _IntervalAltitudeWidgetState();
}

class _IntervalAltitudeWidgetState extends State<IntervalAltitudeWidget> {
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
  void didUpdateWidget(IntervalAltitudeWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> altitudeRecords =
          records.where((Event value) => value.altitude != null).toList();

      if (altitudeRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapAltitudeChart(
                  records: RecordList<Event>(altitudeRecords),
                  minimum: altitudeRecords
                      .map((Event record) => record.altitude ?? 0)
                      .reduce(min)
                      .toDouble(),
                  maximum: altitudeRecords
                      .map((Event record) => record.altitude ?? 0)
                      .reduce(max)
                      .toDouble(),
                ),
              ),
              const Text(
                  'Only records where altitude measurement is present are shown.'),
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
                leading: MyIcon.amount,
                title: PQText(value: altitudeRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No altitude data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    final encrateia.Interval interval = widget.interval!;
    records = RecordList<Event>(await interval.records);

    setState(() => loading = false);
  }
}
