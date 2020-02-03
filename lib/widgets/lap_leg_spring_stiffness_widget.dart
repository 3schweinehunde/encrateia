import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'lap_leg_spring_stiffness_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapLegSpringStiffnessWidget extends StatefulWidget {
  final Lap lap;

  LapLegSpringStiffnessWidget({this.lap});

  @override
  _LapLegSpringStiffnessWidgetState createState() => _LapLegSpringStiffnessWidgetState();
}

class _LapLegSpringStiffnessWidgetState extends State<LapLegSpringStiffnessWidget> {
  List<Event> records = [];
  String avgLegSpringStiffnessString = "Loading ...";
  String sdevLegSpringStiffnessString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerValues =
      records.map((value) => value.db.legSpringStiffness).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapLegSpringStiffnessChart(records: records),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgLegSpringStiffnessString),
                subtitle: Text("average ground time"),
              ),
              ListTile(
                leading: MyIcon.sdev,
                title: Text(sdevLegSpringStiffnessString),
                subtitle: Text("standard deviation ground time"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(records.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No ground time available."),
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
    setState(() {
      avgLegSpringStiffnessString = avg.toStringOrDashes(1) + " ms";
    });

    double sdev = await lap.sdevLegSpringStiffness;
    setState(() {
      sdevLegSpringStiffnessString = sdev.toStringOrDashes(2) + " ms";
    });
  }
}
