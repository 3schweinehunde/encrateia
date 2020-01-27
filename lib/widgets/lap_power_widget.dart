import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'lap_power_chart.dart';

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

    @override
    void initState() {
      getData();
      super.initState();
    }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerValues =
      records.map((value) => value.db.power).nonZero();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapPowerChart(records: records),
              ListTile(
                leading: Icon(Icons.ev_station),
                title: Text(avgPowerString),
                subtitle: Text("average power"),
              ),
              ListTile(
                leading: Icon(Icons.expand_more),
                title: Text(
                    minPowerString),
                subtitle: Text("minimum power"),
              ),
              ListTile(
                leading: Icon(Icons.expand_less),
                title: Text(maxPowerString),
                subtitle: Text("maximum power"),
              ),
              ListTile(
                leading: Icon(Icons.unfold_more),
                title: Text(sdevPowerString),
                subtitle: Text("standard deviation power"),
              ),
              ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text(records.length.toString()),
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
      records = await Event.recordsByLap(lap: lap);

      double avg = await lap.avgPower;
      setState(() {
        avgPowerString = avg.toStringOrDashes(1) + " W";
      });

      int min = await lap.minPower;
      setState(() {
        minPowerString = min.toString() + " W";
      });

      int max = await lap.maxPower;
      setState(() {
        maxPowerString = max.toString() + " W";
      });

      double sdev = await lap.sdevPower;
      setState(() {
        sdevPowerString = sdev.toStringOrDashes(2) + " W";
      });
    }
}
