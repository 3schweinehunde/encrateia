import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'activity_form_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityFormPowerWidget extends StatefulWidget {
  final Activity activity;

  ActivityFormPowerWidget({this.activity});

  @override
  _ActivityFormPowerWidgetState createState() => _ActivityFormPowerWidgetState();
}

class _ActivityFormPowerWidgetState extends State<ActivityFormPowerWidget> {
  List<Event> records = [];
  String avgFormPowerString = "Loading ...";
  String sdevFormPowerString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerValues = records.map((value) => value.db.formPower).nonZeroInts();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityFormPowerChart(records: records, activity: widget.activity),
              ListTile(
                leading: MyIcon.formPower,
                title: Text(avgFormPowerString),
                subtitle: Text("average form power"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevFormPowerString),
                subtitle: Text("standard deviation form power"),
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
          child: Text("No form power data available."),
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

    double avg = await activity.avgFormPower;
    setState(() {
      avgFormPowerString = avg.toStringOrDashes(1) + " W";
    });

    double sdev = await activity.sdevFormPower;
    setState(() {
      sdevFormPowerString = sdev.toStringOrDashes(2) + " W";
    });
  }
}
