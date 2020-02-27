import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/actitvity_charts/activity_stride_ratio_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityStrideRatioWidget extends StatefulWidget {
  final Activity activity;

  ActivityStrideRatioWidget({this.activity});

  @override
  _ActivityStrideRatioWidgetState createState() =>
      _ActivityStrideRatioWidgetState();
}

class _ActivityStrideRatioWidgetState extends State<ActivityStrideRatioWidget> {
  List<Event> records = [];
  String avgStrideRatioString = "Loading ...";
  String sdevStrideRatioString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var strideRatioValues =
          records.map((value) => value.db.verticalOscillation).nonZeroDoubles();
      if (strideRatioValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityStrideRatioChart(
                  records: records, activity: widget.activity),
              Text(
                  "stride ratio = \nstride length (cm) / vertical oscillation (cm)\n"),
              Text(
                  "stridelength (cm) = \n10 000 / 6 * speed (km/h) / cadence (strides/min)"),
              ListTile(
                leading: MyIcon.strideRatio,
                title: Text(avgStrideRatioString),
                subtitle: Text("average stride ratio"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevStrideRatioString),
                subtitle: Text("standard deviation stride ratio "),
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
    avgStrideRatioString = activity.db.avgStrideRatio.toStringOrDashes(1);
    sdevStrideRatioString = activity.db.sdevStrideRatio.toStringOrDashes(2);
    setState(() {});
  }
}
