import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapPowerWidget extends StatefulWidget {
  final Lap lap;

  LapPowerWidget({this.lap});

  @override
  _LapPowerWidgetState createState() => _LapPowerWidgetState();
}

class _LapPowerWidgetState extends State<LapPowerWidget> {
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
    if (records.length > 0) {
      var powerRecords = records
          .where((value) => value.db.power != null && value.db.power > 100)
          .toList();

      if (powerRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapPowerChart(
                records: powerRecords,
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
    Lap lap = widget.lap;
    records = await lap.records;

    double avg = await lap.avgPower;
    avgPowerString = avg.toStringOrDashes(1) + " W";

    int min = await lap.minPower;
    minPowerString = min.toString() + " W";

    int max = await lap.maxPower;
    maxPowerString = max.toString() + " W";

    double sdev = await lap.sdevPower;
    sdevPowerString = sdev.toStringOrDashes(2) + " W";

    powerZoneSchema = await lap.getPowerZoneSchema();
    if (powerZoneSchema != null)
      powerZones = await powerZoneSchema.powerZones;
    else
      powerZones = [];
    setState(() {});
  }
}
