import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_stryd_cadence_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapStrydCadenceWidget extends StatefulWidget {
  final Lap lap;

  LapStrydCadenceWidget({this.lap});

  @override
  _LapStrydCadenceWidgetState createState() => _LapStrydCadenceWidgetState();
}

class _LapStrydCadenceWidgetState extends State<LapStrydCadenceWidget> {
  var records = RecordList({});
  String avgStrydCadenceString = "Loading ...";
  String sdevStrydCadenceString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var strydCadenceRecords = records
          .where((value) =>
              value.db.strydCadence != null && value.db.strydCadence > 0)
          .toList();

      if (strydCadenceRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapStrydCadenceChart(records: strydCadenceRecords),
              Text('Only records where cadence > 0 s/min are shown.'),
              Text('Swipe left/write to compare with other laps.'),
              Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgStrydCadenceString),
                subtitle: Text("average cadence"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevStrydCadenceString),
                subtitle: Text("standard deviation cadence"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(strydCadenceRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No cadence data available."),
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
    records = RecordList(await lap.records);

    double avg = await lap.avgStrydCadence;
    avgStrydCadenceString = avg.toStringOrDashes(1) + " spm";

    double sdev = await lap.sdevStrydCadence;
    setState(() {
      sdevStrydCadenceString = sdev.toStringOrDashes(2) + " spm";
    });
  }
}
