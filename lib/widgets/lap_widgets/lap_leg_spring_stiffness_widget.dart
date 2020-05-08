import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import '../charts/lap_charts/lap_leg_spring_stiffness_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapLegSpringStiffnessWidget extends StatefulWidget {
  final Lap lap;

  LapLegSpringStiffnessWidget({this.lap});

  @override
  _LapLegSpringStiffnessWidgetState createState() =>
      _LapLegSpringStiffnessWidgetState();
}

class _LapLegSpringStiffnessWidgetState
    extends State<LapLegSpringStiffnessWidget> {
  List<Event> records = [];
  String avgLegSpringStiffnessString = "Loading ...";
  String sdevLegSpringStiffnessString = "Loading ...";

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
      var legSpringStiffnessRecords = records
          .where((value) =>
              value.db.legSpringStiffness != null &&
              value.db.legSpringStiffness > 0)
          .toList();

      if (legSpringStiffnessRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapLegSpringStiffnessChart(records: legSpringStiffnessRecords),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgLegSpringStiffnessString),
                subtitle: Text("average ground time"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevLegSpringStiffnessString),
                subtitle: Text("standard deviation ground time"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(legSpringStiffnessRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No leg spring stiffness data available."),
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
    double avg = await lap.avgLegSpringStiffness;
    double sdev = await lap.sdevLegSpringStiffness;
    setState(() {
      avgLegSpringStiffnessString = avg.toStringOrDashes(1) + " ms";
      sdevLegSpringStiffnessString = sdev.toStringOrDashes(2) + " ms";
    });
  }
}
