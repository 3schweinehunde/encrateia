import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/lap.dart';
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_pace_chart.dart';

class LapPaceWidget extends StatefulWidget {
  const LapPaceWidget({Key? key, this.lap}) : super(key: key);

  final Lap? lap;

  @override
  LapPaceWidgetState createState() => LapPaceWidgetState();
}

class LapPaceWidgetState extends State<LapPaceWidget> {
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
  void didUpdateWidget(LapPaceWidget oldWidget) {
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
                child: LapPaceChart(
                  records: RecordList<Event>(paceRecords),
                  minimum: 50 / 3 / widget.lap!.avgSpeed! -
                      3 * widget.lap!.sdevPace!,
                  maximum: 50 / 3 / widget.lap!.avgSpeed! +
                      3 * widget.lap!.sdevPace!,
                ),
              ),
              const Text('Only records where speed > 0 m/s are shown.'),
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
                title: PQText(value: widget.lap!.avgPace, pq: PQ.pace),
                subtitle: const Text('average pace'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title:
                    PQText(value: widget.lap!.minSpeed, pq: PQ.paceFromSpeed),
                subtitle: const Text('minimum pace'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title:
                    PQText(value: widget.lap!.maxSpeed, pq: PQ.paceFromSpeed),
                subtitle: const Text('maximum pace'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.lap!.sdevPace, pq: PQ.pace),
                subtitle: const Text('standard deviation pace'),
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
    final Lap lap = widget.lap!;
    records = RecordList<Event>(await lap.records);
    setState(() => loading = false);
  }
}
