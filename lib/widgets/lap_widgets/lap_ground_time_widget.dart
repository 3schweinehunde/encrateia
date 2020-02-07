import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import '../charts/lap_charts/lap_ground_time_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapGroundTimeWidget extends StatefulWidget {
  final Lap lap;

  LapGroundTimeWidget({this.lap});

  @override
  _LapGroundTimeWidgetState createState() => _LapGroundTimeWidgetState();
}

class _LapGroundTimeWidgetState extends State<LapGroundTimeWidget> {
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
      var powerValues =
      records.map((value) => value.db.groundTime).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapGroundTimeChart(records: records),
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

    double avg = await lap.avgGroundTime;
    setState(() {
      avgGroundTimeString = avg.toStringOrDashes(1) + " ms";
    });

    double sdev = await lap.sdevGroundTime;
    setState(() {
      sdevGroundTimeString = sdev.toStringOrDashes(2) + " ms";
    });
  }
}
