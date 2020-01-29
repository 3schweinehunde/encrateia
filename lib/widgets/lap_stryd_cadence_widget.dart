import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/list_utils.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'lap_stryd_cadence_chart.dart';

class LapStrydCadenceWidget extends StatefulWidget {
  final Lap lap;

  LapStrydCadenceWidget({this.lap});

  @override
  _LapStrydCadenceWidgetState createState() => _LapStrydCadenceWidgetState();
}

class _LapStrydCadenceWidgetState extends State<LapStrydCadenceWidget> {
  List<Event> records = [];
  String avgStrydCadenceString = "Loading ...";
  String sdevStrydCadenceString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerValues =
      records.map((value) => value.db.strydCadence).nonZeroDoubles();
      if (powerValues.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapStrydCadenceChart(records: records),
              ListTile(
                leading: Icon(Icons.ev_station),
                title: Text(avgStrydCadenceString),
                subtitle: Text("average cadence"),
              ),
              ListTile(
                leading: Icon(Icons.unfold_more),
                title: Text(sdevStrydCadenceString),
                subtitle: Text("standard deviation cadence"),
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
          child: Text("No cadence available."),
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

    double avg = await lap.avgStrydCadence;
    setState(() {
      avgStrydCadenceString = avg.toStringOrDashes(1) + " spm";
    });

    double sdev = await lap.sdevStrydCadence;
    setState(() {
      sdevStrydCadenceString = sdev.toStringOrDashes(2) + " spm";
    });
  }
}
