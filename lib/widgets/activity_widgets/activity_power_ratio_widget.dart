import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/actitvity_charts/activity_power_ratio_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityPowerRatioWidget extends StatefulWidget {
  final Activity activity;

  ActivityPowerRatioWidget({this.activity});

  @override
  _ActivityPowerRatioWidgetState createState() =>
      _ActivityPowerRatioWidgetState();
}

class _ActivityPowerRatioWidgetState extends State<ActivityPowerRatioWidget> {
  List<Event> records = [];
  String avgPowerRatioString = "Loading ...";
  String sdevPowerRatioString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerRecords = records
          .where((value) =>
              value.db.power != null &&
              value.db.power > 0 &&
              value.db.formPower != null &&
              value.db.formPower > 0 &&
              value.db.formPower < 200)
          .toList();

      if (powerRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityPowerRatioChart(
                records: powerRecords,
                activity: widget.activity,
              ),
              Text("power ratio (%) = (power - form power) / power * 100"),
              ListTile(
                leading: MyIcon.formPower,
                title: Text(avgPowerRatioString),
                subtitle: Text("average power ratio"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevPowerRatioString),
                subtitle: Text("standard deviation power ratio "),
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
          child: Text("No power ratio data available."),
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
    avgPowerRatioString = activity.db.avgPowerRatio.toStringOrDashes(1) + " %";
    sdevPowerRatioString =
        activity.db.sdevPowerRatio.toStringOrDashes(2) + " %";
    setState(() {});
  }
}
