import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/actitvity_charts/activity_stride_ratio_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityStrideRatioWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityStrideRatioWidget({
    @required this.activity,
    @required this.athlete,
  });

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
      var strideRatioRecords = records
          .where((value) =>
              value.db.strydCadence != null &&
              value.db.verticalOscillation != null &&
              value.db.verticalOscillation != 0)
          .toList();

      if (strideRatioRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityStrideRatioChart(
                records: strideRatioRecords,
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text("stride ratio = stride length (cm) / vertical oscillation"
                  " (cm)"),
              Text("stridelength (cm) = 10 000 / 6 * speed (km/h) / cadence "
                  "(strides/min)"),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'cadence is present and vertical oscillation > 0 mm are shown.'),
              Divider(),
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
                title: Text(strideRatioRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No stride ratio data available."),
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
