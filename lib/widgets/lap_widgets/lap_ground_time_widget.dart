import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_ground_time_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapGroundTimeWidget extends StatefulWidget {
  const LapGroundTimeWidget({this.lap});

  final Lap lap;

  @override
  _LapGroundTimeWidgetState createState() => _LapGroundTimeWidgetState();
}

class _LapGroundTimeWidgetState extends State<LapGroundTimeWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgGroundTimeString = 'Loading ...';
  String sdevGroundTimeString = 'Loading ...';

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
              (Event value) => value.db.groundTime != null && value.db.groundTime > 0)
          .toList();

      if (groundTimeRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapGroundTimeChart(records: RecordList<Event>(groundTimeRecords)),
              const Text('Only records where ground time > 0 ms are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgGroundTimeString),
                subtitle: const Text('average ground time'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevGroundTimeString),
                subtitle: const Text('standard deviation ground time'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(groundTimeRecords.length.toString()),
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
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Lap lap = widget.lap;
    records = RecordList<Event>(await lap.records);

    final double avg = await lap.avgGroundTime;
    avgGroundTimeString = avg.toStringOrDashes(1) + ' ms';

    final double sdev = await lap.sdevGroundTime;
    setState(() {
      sdevGroundTimeString = sdev.toStringOrDashes(2) + ' ms';
    });
  }
}
