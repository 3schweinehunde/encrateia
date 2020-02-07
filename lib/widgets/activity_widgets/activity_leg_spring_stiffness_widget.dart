import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import '../charts/actitvity_charts/activity_leg_spring_stiffness_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityLegSpringStiffnessWidget extends StatefulWidget {
  final Activity activity;

  ActivityLegSpringStiffnessWidget({this.activity});

  @override
  _ActivityLegSpringStiffnessWidgetState createState() => _ActivityLegSpringStiffnessWidgetState();
}

class _ActivityLegSpringStiffnessWidgetState extends State<ActivityLegSpringStiffnessWidget> {
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
      var powerValues = records.map((value) => value.db.groundTime).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityLegSpringStiffnessChart(records: records, activity: widget.activity),
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
                title: Text(records.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No ground time data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    Activity activity = widget.activity;
    records = await activity.records;

    double avg = await activity.avgLegSpringStiffness;
    setState(() {
      avgLegSpringStiffnessString = avg.toStringOrDashes(1) + " ms";
    });

    double sdev = await activity.sdevLegSpringStiffness;
    setState(() {
      sdevLegSpringStiffnessString = sdev.toStringOrDashes(2) + " ms";
    });
  }
}
