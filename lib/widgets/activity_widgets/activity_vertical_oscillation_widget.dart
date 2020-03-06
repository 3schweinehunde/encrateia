import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import '../charts/actitvity_charts/activity_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityVerticalOscillationWidget extends StatefulWidget {
  final Activity activity;

  ActivityVerticalOscillationWidget({this.activity});

  @override
  _ActivityVerticalOscillationWidgetState createState() =>
      _ActivityVerticalOscillationWidgetState();
}

class _ActivityVerticalOscillationWidgetState
    extends State<ActivityVerticalOscillationWidget> {
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
      var powerRecords = records
          .where((value) => value.db.power != null && value.db.power > 100)
          .toList();
      if (powerRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityVerticalOscillationChart(
                  records: powerRecords, activity: widget.activity),
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
                title: Text(powerRecords.length.toString()),
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
    Activity activity = widget.activity;
    records = await activity.records;
    avgVerticalOscillationString =
        activity.db.avgVerticalOscillation.toStringOrDashes(1) + " cm";
    sdevVerticalOscillationString =
        activity.db.sdevVerticalOscillation.toStringOrDashes(2) + " cm";
    setState(() {});
  }
}
