import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/widgets/charts/lap_charts/lap_ecor_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class IntervalEcorWidget extends StatefulWidget {
  const IntervalEcorWidget({
    @required this.interval,
    @required this.athlete,
  });

  final encrateia.Interval interval;
  final Athlete athlete;

  @override
  _IntervalEcorWidgetState createState() => _IntervalEcorWidgetState();
}

class _IntervalEcorWidgetState extends State<IntervalEcorWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  Weight weight;
  bool loading = true;
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalEcorWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) =>
      value.power != null &&
          value.power > 100 &&
          value.speed != null &&
          value.speed >= 1)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapEcorChart(
                  records: RecordList<Event>(powerRecords),
                  weight: weight.value,
                ),
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 0 W and speed > 1 m/s are shown.'),
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
                leading: MyIcon.weight,
                title: PQText(value: widget.interval.weight, pq: PQ.weight),
                subtitle: const Text('weight'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: powerRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
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
    weight = await Weight.getBy(
      athletesId: widget.athlete.id,
      date: widget.interval.timeStamp,
    );
    widget.interval.weight = weight?.value;
    setState(() => loading = false);
  }
}
