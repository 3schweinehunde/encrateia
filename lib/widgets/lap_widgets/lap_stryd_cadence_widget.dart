import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/lap.dart';
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_stryd_cadence_chart.dart';

class LapStrydCadenceWidget extends StatefulWidget {
  const LapStrydCadenceWidget({Key? key, this.lap}) : super(key: key);

  final Lap? lap;

  @override
  LapStrydCadenceWidgetState createState() => LapStrydCadenceWidgetState();
}

class LapStrydCadenceWidgetState extends State<LapStrydCadenceWidget> {
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
  void didUpdateWidget(LapStrydCadenceWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> strydCadenceRecords = records
          .where((Event value) =>
              value.strydCadence != null && value.strydCadence! > 0)
          .toList();

      if (strydCadenceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapStrydCadenceChart(
                  records: RecordList<Event>(strydCadenceRecords),
                  minimum: widget.lap!.avgStrydCadence! * 2 / 1.25,
                  maximum: widget.lap!.avgStrydCadence! * 2 * 1.25,
                ),
              ),
              const Text('Only records where cadence > 0 s/min are shown.'),
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
                  value: widget.lap!.avgStrydCadence,
                  pq: PQ.cadence,
                ),
                subtitle: const Text('average cadence'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.lap!.sdevStrydCadence,
                  pq: PQ.cadence,
                ),
                subtitle: const Text('standard deviation cadence'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title:
                    PQText(value: strydCadenceRecords.length, pq: PQ.integer),
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
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.lap!.records);
    setState(() => loading = false);
  }
}
