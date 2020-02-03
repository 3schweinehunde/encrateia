import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'activity_stryd_cadence_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityStrydCadenceWidget extends StatefulWidget {
  final Activity activity;

  ActivityStrydCadenceWidget({this.activity});

  @override
  _ActivityStrydCadenceWidgetState createState() => _ActivityStrydCadenceWidgetState();
}

class _ActivityStrydCadenceWidgetState extends State<ActivityStrydCadenceWidget> {
  List<Event> records = [];
  String avgStrydCadenceString = "Loading ...";
  String sdevStrydCadenceString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerValues = records.map((value) => value.db.strydCadence).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityStrydCadenceChart(records: records, activity: widget.activity),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgStrydCadenceString),
                subtitle: Text("average cadence"),
              ),
              ListTile(
                leading: MyIcon.sdev,
                title: Text(sdevStrydCadenceString),
                subtitle: Text("standard deviation cadence"),
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
          child: Text("No cadence data available."),
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

    double avg = await activity.avgStrydCadence;
    setState(() {
      avgStrydCadenceString = avg.toStringOrDashes(1) + " spm";
    });

    double sdev = await activity.sdevStrydCadence;
    setState(() {
      sdevStrydCadenceString = sdev.toStringOrDashes(2) + " spm";
    });
  }
}
