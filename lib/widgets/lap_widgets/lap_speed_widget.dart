import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/event.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_speed_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapSpeedWidget extends StatefulWidget {
  const LapSpeedWidget({this.lap});

  final Lap lap;

  @override
  _LapSpeedWidgetState createState() => _LapSpeedWidgetState();
}

class _LapSpeedWidgetState extends State<LapSpeedWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapSpeedWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> paceRecords = records
          .where((Event value) => value.speed != null && value.speed > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              LapSpeedChart(
                records: RecordList<Event>(paceRecords),
                minimum: (widget.lap.avgSpeed - 3 * widget.lap.sdevSpeed) * 3.6,
                maximum: (widget.lap.avgSpeed + 3 * widget.lap.sdevSpeed) * 3.6,
              ),
              const Text('Only records where speed > 0 m/s are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(
                    (widget.lap.avgSpeed * 3.6).toStringAsFixed(2) + ' km/h'),
                subtitle: const Text('average pace'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(
                    (widget.lap.minSpeed * 3.6).toStringAsFixed(2) + ' km/h'),
                subtitle: const Text('minimum pace'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(
                    (widget.lap.maxSpeed * 3.6).toStringAsFixed(2) + ' km/h'),
                subtitle: const Text('maximum pace'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(
                    (widget.lap.sdevSpeed * 3.6).toStringAsFixed(2) + ' km/h'),
                subtitle: const Text('standard deviation pace'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(paceRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No heart rate data available.'),
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
    setState(() {});
  }
}
