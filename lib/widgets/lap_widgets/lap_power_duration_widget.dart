import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/image_utils.dart' as image_utils;
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/widgets/charts/power_duration_chart.dart';
import 'package:flutter/material.dart';

class LapPowerDurationWidget extends StatefulWidget {
  const LapPowerDurationWidget({@required this.lap});

  final Lap lap;

  @override
  _LapPowerDurationWidgetState createState() => _LapPowerDurationWidgetState();
}

class _LapPowerDurationWidgetState extends State<LapPowerDurationWidget> {
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
  void didUpdateWidget(LapPowerDurationWidget oldWidget) {
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
            const Text('Swipe left/write to compare with other laps.'),
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
    records = RecordList<Event>(await widget.lap.records);
    setState(() => loading = false);
  }
}
