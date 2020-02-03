import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'activity_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityVerticalOscillationWidget extends StatefulWidget {
  final Activity activity;

  ActivityVerticalOscillationWidget({this.activity});

  @override
  _ActivityVerticalOscillationWidgetState createState() => _ActivityVerticalOscillationWidgetState();
}

class _ActivityVerticalOscillationWidgetState extends State<ActivityVerticalOscillationWidget> {
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
      var powerValues = records.map((value) => value.db.verticalOscillation).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityVerticalOscillationChart(records: records, activity: widget.activity),
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

    double avg = await activity.avgVerticalOscillation;
    setState(() {
      avgVerticalOscillationString = avg.toStringOrDashes(1) + " cm";
    });

    double sdev = await activity.sdevVerticalOscillation;
    setState(() {
      sdevVerticalOscillationString = sdev.toStringOrDashes(2) + " cm";
    });
  }
}
