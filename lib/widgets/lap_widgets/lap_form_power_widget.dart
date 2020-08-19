import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_form_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class LapFormPowerWidget extends StatefulWidget {
  const LapFormPowerWidget({this.lap});

  final Lap lap;

  @override
  _LapFormPowerWidgetState createState() => _LapFormPowerWidgetState();
}

class _LapFormPowerWidgetState extends State<LapFormPowerWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapFormPowerWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> formPowerRecords = records
          .where(
              (Event value) => value.formPower != null && value.formPower > 0)
          .toList();

      if (formPowerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapFormPowerChart(
                records: RecordList<Event>(formPowerRecords),
                minimum: widget.lap.avgFormPower / 1.1,
                maximum: widget.lap.avgFormPower * 1.25,
              ),
              const Text(
                  'Only records where 0 W < form power < 200 W are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: PQText(value: widget.lap.avgFormPower, pq: PQ.power),
                subtitle: const Text('average form power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.lap.sdevFormPower, pq: PQ.power),
                subtitle: const Text('standard deviation form power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: formPowerRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No form power data available.'),
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
