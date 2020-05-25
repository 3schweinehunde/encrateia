import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_power_per_heart_rate_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityPowerPerHeartRateWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityPowerPerHeartRateWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  _ActivityPowerPerHeartRateWidgetState createState() =>
      _ActivityPowerPerHeartRateWidgetState();
}

class _ActivityPowerPerHeartRateWidgetState
    extends State<ActivityPowerPerHeartRateWidget> {
  List<Event> records = [];
  String avgPowerPerHeartRateString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerPerHeartRateRecords = records
          .where((value) =>
              value.db.power != null &&
              value.db.power > 100 &&
              value.db.heartRate != null &&
              value.db.heartRate > 0)
          .toList();

      if (powerPerHeartRateRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityPowerPerHeartRateChart(
                records: powerPerHeartRateRecords,
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 100 W and heart rate > 0 bpm are shown.'),
              Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgPowerPerHeartRateString),
                subtitle: Text("average power per heart rate"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No power per heart rate data available."),
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
    double avg = activity.db.avgPower / activity.db.avgHeartRate;
    avgPowerPerHeartRateString = avg.toStringOrDashes(2) + " W / bpm";
    setState(() {});
  }
}
