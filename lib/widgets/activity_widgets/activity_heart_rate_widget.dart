import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/widgets/charts/actitvity_charts/activity_heart_rate_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityHeartRateWidget extends StatefulWidget {
  final Activity activity;

  ActivityHeartRateWidget({this.activity});

  @override
  _ActivityHeartRateWidgetState createState() =>
      _ActivityHeartRateWidgetState();
}

class _ActivityHeartRateWidgetState extends State<ActivityHeartRateWidget> {
  List<Event> records = [];
  HeartRateZoneSchema heartRateZoneSchema;
  List<HeartRateZone> heartRateZones;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records != null) {
      var heartRateRecords = records
          .where(
              (value) => value.db.heartRate != null && value.db.heartRate > 10)
          .toList();

      if (heartRateRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityHeartRateChart(
                records: heartRateRecords,
                activity: widget.activity,
                heartRateZones: heartRateZones,
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(widget.activity.db.avgHeartRate.toString()),
                subtitle: Text("average heart rate"),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(Lap.minHeartRate(records: records)),
                subtitle: Text("minimum heart rate"),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(widget.activity.db.maxHeartRate.toString()),
                subtitle: Text("maximum heart rate"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(Lap.sdevHeartRate(records: records)),
                subtitle: Text("standard deviation heart rate"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(heartRateRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No heart rate data available."),
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

    heartRateZoneSchema = await activity.getHeartRateZoneSchema();
    if (heartRateZoneSchema != null)
      heartRateZones = await heartRateZoneSchema.heartRateZones;
    else
      heartRateZones = [];
    setState(() {});
  }
}
