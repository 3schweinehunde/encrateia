import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/models/event.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_ecor_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/num_utils.dart';

class LapEcorWidget extends StatefulWidget {
  const LapEcorWidget({
    @required this.lap,
    @required this.athlete,
  });

  final Lap lap;
  final Athlete athlete;

  @override
  _LapEcorWidgetState createState() => _LapEcorWidgetState();
}

class _LapEcorWidgetState extends State<LapEcorWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  Weight weight;
  String weightString;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapEcorWidget oldWidget) {
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
              LapEcorChart(
                records: RecordList<Event>(powerRecords),
                weight: weight.value,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 0 W and speed > 1 m/s are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.weight,
                title: Text(weightString),
                subtitle: const Text('weight'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(powerRecords.length.toString()),
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
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.lap.records);
    weight = await Weight.getBy(
      athletesId: widget.athlete.db.id,
      date: widget.lap.db.startTime,
    );
    weightString = weight.value.toStringOrDashes(2) + ' kg';
    setState(() {});
  }
}
