import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import '../charts/lap_charts/lap_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapVerticalOscillationWidget extends StatefulWidget {
  final Lap lap;

  LapVerticalOscillationWidget({this.lap});

  @override
  _LapVerticalOscillationWidgetState createState() =>
      _LapVerticalOscillationWidgetState();
}

class _LapVerticalOscillationWidgetState
    extends State<LapVerticalOscillationWidget> {
  List<Event> records = [];
  String avgVerticalOscillationString = "Loading ...";
  String sdevVerticalOscillationString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var verticalOscillationRecords = records
          .where((value) =>
              value.db.verticalOscillation != null &&
              value.db.verticalOscillation > 0)
          .toList();

      if (verticalOscillationRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapVerticalOscillationChart(records: verticalOscillationRecords),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgVerticalOscillationString),
                subtitle: Text("average vertical oscillation"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevVerticalOscillationString),
                subtitle: Text("standard deviation vertical oscillation"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(verticalOscillationRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No vertical oscillation data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    Lap lap = widget.lap;
    records = await lap.records;

    double avg = await lap.avgVerticalOscillation;
    avgVerticalOscillationString = avg.toStringOrDashes(1) + " cm";

    double sdev = await lap.sdevVerticalOscillation;
    setState(() {
      sdevVerticalOscillationString = sdev.toStringOrDashes(2) + " cm";
    });
  }
}
