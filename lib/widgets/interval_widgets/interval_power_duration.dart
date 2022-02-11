import 'package:flutter/material.dart';

import '/models/event.dart';
import '/models/interval.dart' as encrateia;
import '/models/record_list.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/power_duration_chart.dart';

class IntervalPowerDurationWidget extends StatefulWidget {
  const IntervalPowerDurationWidget({@required this.interval});

  final encrateia.Interval interval;

  @override
  _IntervalPowerDurationWidgetState createState() =>
      _IntervalPowerDurationWidgetState();
}

class _IntervalPowerDurationWidgetState
    extends State<IntervalPowerDurationWidget> {
  List<Event> records = <Event>[];
  bool loading = true;
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalPowerDurationWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListView(
          padding: const EdgeInsets.only(left: 15),
          children: <Widget>[
            RepaintBoundary(
              key: widgetKey,
              child: PowerDurationChart(records: powerRecords),
            ),
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
          ],
        );
      } else {
        return const Center(
          child: Text('No power data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.interval.records);
    setState(() => loading = false);
  }
}
