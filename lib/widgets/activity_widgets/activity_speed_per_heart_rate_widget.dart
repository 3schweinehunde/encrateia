import 'package:encrateia/widgets/charts/actitvity_charts/activity_speed_per_heart_rate_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivitySpeedPerHeartRateWidget extends StatefulWidget {
  final Activity activity;

  ActivitySpeedPerHeartRateWidget({this.activity});

  @override
  _ActivitySpeedPerHeartRateWidgetState createState() =>
      _ActivitySpeedPerHeartRateWidgetState();
}

class _ActivitySpeedPerHeartRateWidgetState
    extends State<ActivitySpeedPerHeartRateWidget> {
  List<Event> records = [];
  String avgSpeedPerHeartRateString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var speedPerHeartRateRecords = records
          .where((value) =>
              value.db.speed != null &&
              value.db.heartRate != null &&
              value.db.heartRate > 0)
          .toList();

      if (speedPerHeartRateRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivitySpeedPerHeartRateChart(
                records: speedPerHeartRateRecords,
                activity: widget.activity,
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgSpeedPerHeartRateString),
                subtitle: Text("average speed per heart rate"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No speed per heart rate data available."),
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

    double avg = 1000 * activity.db.avgSpeed / activity.db.avgHeartRate;
    avgSpeedPerHeartRateString = avg.toStringOrDashes(1) + " m/h / bpm";
    setState(() {});
  }
}
