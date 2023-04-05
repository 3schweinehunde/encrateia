import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/interval.dart' as encrateia;
import '/models/record_list.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_vertical_oscillation_chart.dart';

class IntervalVerticalOscillationWidget extends StatefulWidget {
  const IntervalVerticalOscillationWidget({Key? key, this.interval})
      : super(key: key);

  final encrateia.Interval? interval;

  @override
  IntervalVerticalOscillationWidgetState createState() =>
      IntervalVerticalOscillationWidgetState();
}

class IntervalVerticalOscillationWidgetState
    extends State<IntervalVerticalOscillationWidget> {
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
  void didUpdateWidget(IntervalVerticalOscillationWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> verticalOscillationRecords = records
          .where((Event value) =>
              value.verticalOscillation != null &&
              value.verticalOscillation! > 0)
          .toList();

      if (verticalOscillationRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapVerticalOscillationChart(
                  records: RecordList<Event>(verticalOscillationRecords),
                  minimum: widget.interval!.avgVerticalOscillation! / 1.25,
                  maximum: widget.interval!.avgVerticalOscillation! * 1.25,
                ),
              ),
              const Text(
                  'Only records where vertical oscillation is present are shown.'),
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
                  value: widget.interval!.avgVerticalOscillation,
                  pq: PQ.verticalOscillation,
                ),
                subtitle: const Text('average vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.interval!.sdevVerticalOscillation,
                  pq: PQ.verticalOscillation,
                ),
                subtitle: const Text('standard deviation vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(
                  value: verticalOscillationRecords.length,
                  pq: PQ.integer,
                ),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No vertical oscillation data available.'),
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
