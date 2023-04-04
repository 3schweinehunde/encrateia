import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/lap.dart';
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_leg_spring_stiffness_chart.dart';

class LapLegSpringStiffnessWidget extends StatefulWidget {
  const LapLegSpringStiffnessWidget({Key? key, this.lap}) : super(key: key);

  final Lap? lap;

  @override
  createState() => LapLegSpringStiffnessWidgetState();
}

class LapLegSpringStiffnessWidgetState
    extends State<LapLegSpringStiffnessWidget> {
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
  void didUpdateWidget(LapLegSpringStiffnessWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> legSpringStiffnessRecords = records
          .where((Event value) =>
              value.legSpringStiffness != null && value.legSpringStiffness! > 0)
          .toList();

      if (legSpringStiffnessRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapLegSpringStiffnessChart(
                  records: RecordList<Event>(legSpringStiffnessRecords),
                  minimum: widget.lap!.avgLegSpringStiffness! / 1.20,
                  maximum: widget.lap!.avgLegSpringStiffness! * 1.20,
                ),
              ),
              const Text('Only records where leg spring stiffness > 0 kN/m '
                  'are shown.'),
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
                  value: widget.lap!.avgLegSpringStiffness,
                  pq: PQ.legSpringStiffness,
                ),
                subtitle: const Text('average leg spring stiffness'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.lap!.sdevLegSpringStiffness,
                  pq: PQ.legSpringStiffness,
                ),
                subtitle: const Text('standard leg spring stiffness'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(
                  value: legSpringStiffnessRecords.length,
                  pq: PQ.integer,
                ),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No leg spring stiffness data available.'),
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
