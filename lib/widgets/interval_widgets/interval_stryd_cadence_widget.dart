import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_stryd_cadence_chart.dart';
import 'package:flutter/material.dart';

class IntervalStrydCadenceWidget extends StatefulWidget {
  const IntervalStrydCadenceWidget({this.interval});

  final encrateia.Interval interval;

  @override
  _IntervalStrydCadenceWidgetState createState() =>
      _IntervalStrydCadenceWidgetState();
}

class _IntervalStrydCadenceWidgetState
    extends State<IntervalStrydCadenceWidget> {
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
  void didUpdateWidget(IntervalStrydCadenceWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> strydCadenceRecords = records
          .where((Event value) =>
              value.strydCadence != null && value.strydCadence > 0)
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
                  minimum: widget.interval.avgStrydCadence * 2 / 1.25,
                  maximum: widget.interval.avgStrydCadence * 2 * 1.25,
                ),
              ),
              const Text('Only records where cadence > 0 s/min are shown.'),
              const Text('Swipe left/write to compare with other intervals.'),
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
                title: PQText(
                  value: widget.interval.avgStrydCadence,
                  pq: PQ.cadence,
                ),
                subtitle: const Text('average cadence'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(
                  value: widget.interval.sdevStrydCadence,
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
    records = RecordList<Event>(await widget.interval.records);
    setState(() => loading = false);
  }
}
