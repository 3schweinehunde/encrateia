import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'activity_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityPowerWidget extends StatefulWidget {
  final Activity activity;

  ActivityPowerWidget({this.activity});

  @override
  _ActivityPowerWidgetState createState() => _ActivityPowerWidgetState();
}

class _ActivityPowerWidgetState extends State<ActivityPowerWidget> {
  List<Event> records = [];
  String avgPowerString = "Loading ...";
  String minPowerString = "Loading ...";
  String maxPowerString = "Loading ...";
  String sdevPowerString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerValues = records.map((value) => value.db.power).nonZeroInts();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityPowerChart(records: records, activity: widget.activity),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgPowerString),
                subtitle: Text("average power"),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(minPowerString),
                subtitle: Text("minimum power"),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(maxPowerString),
                subtitle: Text("maximum power"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevPowerString),
                subtitle: Text("standard deviation power"),
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
    Activity activity = widget.activity;
    records = await activity.records;

    double avg = await activity.avgPower;
    setState(() {
      avgPowerString = avg.toStringOrDashes(1) + " W";
    });

    int min = await activity.minPower;
    setState(() {
      minPowerString = min.toString() + " W";
    });

    int max = await activity.maxPower;
    setState(() {
      maxPowerString = max.toString() + " W";
    });

    double sdev = await activity.sdevPower;
    setState(() {
      sdevPowerString = sdev.toStringOrDashes(2) + " W";
    });
  }
}
