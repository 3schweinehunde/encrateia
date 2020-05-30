import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class LapVerticalOscillationWidget extends StatefulWidget {
  const LapVerticalOscillationWidget({this.lap});

  final Lap lap;
  
  @override
  _LapVerticalOscillationWidgetState createState() =>
      _LapVerticalOscillationWidgetState();
}

class _LapVerticalOscillationWidgetState
    extends State<LapVerticalOscillationWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgVerticalOscillationString = 'Loading ...';
  String sdevVerticalOscillationString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapVerticalOscillationWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> verticalOscillationRecords = records
          .where((Event value) =>
              value.db.verticalOscillation != null &&
              value.db.verticalOscillation > 0)
          .toList();

      if (verticalOscillationRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapVerticalOscillationChart(
                records: RecordList<Event>(verticalOscillationRecords),
              ),
              const Text(
                  'Only records where vertical oscillation is present are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgVerticalOscillationString),
                subtitle: const Text('average vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevVerticalOscillationString),
                subtitle: const Text('standard deviation vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(verticalOscillationRecords.length.toString()),
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
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Lap lap = widget.lap;
    records = RecordList<Event>(await lap.records);

    final double avg = await lap.avgVerticalOscillation;
    avgVerticalOscillationString = avg.toStringOrDashes(1) + ' cm';

    final double sdev = await lap.sdevVerticalOscillation;
    setState(() {
      sdevVerticalOscillationString = sdev.toStringOrDashes(2) + ' cm';
    });
  }
}
