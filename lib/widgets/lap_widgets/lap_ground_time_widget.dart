import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/image_utils.dart' as image_utils;
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_ground_time_chart.dart';
import 'package:flutter/material.dart';

class LapGroundTimeWidget extends StatefulWidget {
  const LapGroundTimeWidget({this.lap});

  final Lap lap;

  @override
  _LapGroundTimeWidgetState createState() => _LapGroundTimeWidgetState();
}

class _LapGroundTimeWidgetState extends State<LapGroundTimeWidget> {
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
  void didUpdateWidget(LapGroundTimeWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> groundTimeRecords = records
          .where(
              (Event value) => value.groundTime != null && value.groundTime > 0)
          .toList();

      if (groundTimeRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapGroundTimeChart(
                  records: RecordList<Event>(groundTimeRecords),
                  minimum: widget.lap.avgGroundTime / 1.25,
                  maximum: widget.lap.avgGroundTime * 1.25,
                ),
              ),
              const Text('Only records where ground time > 0 ms are shown.'),
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
              ListTile(
                leading: MyIcon.average,
                title: PQText(
                  value: widget.lap.avgGroundTime,
                  pq: PQ.groundTime,
                ),
                subtitle: const Text('average ground time'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.lap.sdevGroundTime,
                  pq: PQ.groundTime,
                ),
                subtitle: const Text('standard deviation ground time'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: groundTimeRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No ground time available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    final Lap lap = widget.lap;
    records = RecordList<Event>(await lap.records);
    setState(() => loading = false);
  }
}
