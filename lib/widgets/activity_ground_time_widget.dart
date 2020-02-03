import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'activity_ground_time_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityGroundTimeWidget extends StatefulWidget {
  final Activity activity;

  ActivityGroundTimeWidget({this.activity});

  @override
  _ActivityGroundTimeWidgetState createState() => _ActivityGroundTimeWidgetState();
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
      var powerValues = records.map((value) => value.db.groundTime).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityGroundTimeChart(records: records, activity: widget.activity),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgGroundTimeString),
                subtitle: Text("average ground time"),
              ),
              ListTile(
                leading: MyIcon.sdev,
                title: Text(sdevGroundTimeString),
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

    double avg = await activity.avgGroundTime;
    setState(() {
      avgGroundTimeString = avg.toStringOrDashes(1) + " ms";
    });

    double sdev = await activity.sdevGroundTime;
    setState(() {
      sdevGroundTimeString = sdev.toStringOrDashes(2) + " ms";
    });
  }
}
