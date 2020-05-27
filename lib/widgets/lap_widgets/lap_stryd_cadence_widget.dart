import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_stryd_cadence_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class LapStrydCadenceWidget extends StatefulWidget {
  const LapStrydCadenceWidget({this.lap});

  final Lap lap;

  @override
  _LapStrydCadenceWidgetState createState() => _LapStrydCadenceWidgetState();
}

class _LapStrydCadenceWidgetState extends State<LapStrydCadenceWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgStrydCadenceString = 'Loading ...';
  String sdevStrydCadenceString = 'Loading ...';

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
              value.db.strydCadence != null && value.db.strydCadence > 0)
          .toList();

      if (strydCadenceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapStrydCadenceChart(records: RecordList<Event>(strydCadenceRecords)),
              const Text('Only records where cadence > 0 s/min are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgStrydCadenceString),
                subtitle: const Text('average cadence'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevStrydCadenceString),
                subtitle: const Text('standard deviation cadence'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(strydCadenceRecords.length.toString()),
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
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Lap lap = widget.lap;
    records = RecordList<Event>(await lap.records);

    final double avg = await lap.avgStrydCadence;
    avgStrydCadenceString = avg.toStringOrDashes(1) + ' spm';

    final double sdev = await lap.sdevStrydCadence;
    setState(() {
      sdevStrydCadenceString = sdev.toStringOrDashes(2) + ' spm';
    });
  }
}
