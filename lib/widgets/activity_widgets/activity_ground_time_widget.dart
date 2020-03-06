import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import '../charts/actitvity_charts/activity_ground_time_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityGroundTimeWidget extends StatefulWidget {
  final Activity activity;

  ActivityGroundTimeWidget({this.activity});

  @override
  _ActivityGroundTimeWidgetState createState() =>
      _ActivityGroundTimeWidgetState();
}

class _ActivityGroundTimeWidgetState extends State<ActivityGroundTimeWidget> {
  List<Event> records = [];
  String avgGroundTimeString = "Loading ...";
  String sdevGroundTimeString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var groundTimeRecords = records.where(
          (value) => value.db.groundTime != null && value.db.groundTime > 0);
      if (groundTimeRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityGroundTimeChart(
                records: groundTimeRecords,
                activity: widget.activity,
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgGroundTimeString),
                subtitle: Text("average ground time"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevGroundTimeString),
                subtitle: Text("standard deviation ground time"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(groundTimeRecords.length.toString()),
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
    avgGroundTimeString = activity.db.avgGroundTime != null
        ? activity.db.avgGroundTime.toStringOrDashes(1) + " ms"
        : "- - -";
    sdevGroundTimeString =
        activity.db.sdevGroundTime.toStringOrDashes(2) + " ms";
    setState(() {});
  }
}
