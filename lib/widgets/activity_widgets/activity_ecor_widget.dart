import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/actitvity_charts/activity_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/date_time_utils.dart';

class ActivityEcorWidget extends StatefulWidget {
  final Activity activity;

  ActivityEcorWidget({this.activity});

  @override
  _ActivityEcorWidgetState createState() => _ActivityEcorWidgetState();
}

class _ActivityEcorWidgetState extends State<ActivityEcorWidget> {
  List<Event> records = [];
  String avgPowerString = "Loading ...";
  String minPowerString = "Loading ...";
  String maxPowerString = "Loading ...";
  String sdevPowerString = "Loading ...";
  PowerZoneSchema powerZoneSchema;
  List<PowerZone> powerZones;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0 && powerZones != null) {
      var powerRecords = records
          .where((value) => value.db.power != null && value.db.power > 100)
          .toList();

      if (powerRecords.length > 0) {
        var lastRecord = powerRecords.last;
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityPowerChart(
                records: powerRecords,
                activity: widget.activity,
                powerZones: powerZones,
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgPowerString),
                subtitle: Text("average power"),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(minPowerString),
                subtitle: Text("minimum power"),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(maxPowerString),
                subtitle: Text("maximum power"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevPowerString),
                subtitle: Text("standard deviation power"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(powerRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
              ListTile(
                leading: Text("🕵️‍♀️", style: TextStyle(fontSize: 25)),
                title: Text(lastRecord.db.positionLong.semicirclesAsDegrees() +
                    " / " +
                    lastRecord.db.positionLat.semicirclesAsDegrees()),
                subtitle: Text("findYourStryd (last power record)"),
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
    avgPowerString = activity.db.avgPower.toStringOrDashes(1) + " W";
    minPowerString = activity.db.minPower.toString() + " W";
    maxPowerString = activity.db.maxPower.toString() + " W";
    sdevPowerString = activity.db.sdevPower.toStringOrDashes(2) + " W";

    powerZoneSchema = await activity.getPowerZoneSchema();
    if (powerZoneSchema != null)
      powerZones = await powerZoneSchema.powerZones;
    else
      powerZones = [];
    setState(() {});
  }
}
