import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/power_duration_chart.dart';

class LapPowerDurationWidget extends StatefulWidget {
  final Lap lap;

  LapPowerDurationWidget({@required this.lap});

  @override
  _LapPowerDurationWidgetState createState() => _LapPowerDurationWidgetState();
}

class _LapPowerDurationWidgetState extends State<LapPowerDurationWidget> {
  List<Event> records = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerRecords = records
          .where((value) => value.db.power != null && value.db.power > 100)
          .toList();

      if (powerRecords.length > 0) {
        return ListView(
          padding: EdgeInsets.only(left: 15),
          children: <Widget>[
            PowerDurationChart(records: powerRecords),
            Text('Swipe left/write to compare with other laps.'),
            Divider(),
          ],
        );
      } else {
        return Center(
          child: Text("No power data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    records = await widget.lap.records;
    setState(() {});
  }
}
