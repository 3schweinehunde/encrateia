import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import '../charts/lap_charts/lap_form_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapFormPowerWidget extends StatefulWidget {
  final Lap lap;

  LapFormPowerWidget({this.lap});

  @override
  _LapFormPowerWidgetState createState() => _LapFormPowerWidgetState();
}

class _LapFormPowerWidgetState extends State<LapFormPowerWidget> {
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
      var powerValues =
      records.map((value) => value.db.formPower).nonZeroInts();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapFormPowerChart(records: records),
              ListTile(
                leading: MyIcon.average,
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
    Lap lap = widget.lap;
    records = await lap.records;

    double avg = await lap.avgFormPower;
    setState(() {
      avgFormPowerString = avg.toStringOrDashes(1) + " W";
    });

    double sdev = await lap.sdevFormPower;
    setState(() {
      sdevFormPowerString = sdev.toStringOrDashes(2) + " W";
    });
  }
}
