import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class LapVerticalOscillationWidget extends StatefulWidget {
  final Lap lap;

  LapVerticalOscillationWidget({this.lap});

  @override
  _LapVerticalOscillationWidgetState createState() =>
      _LapVerticalOscillationWidgetState();
}

class _LapVerticalOscillationWidgetState
    extends State<LapVerticalOscillationWidget> {
  var records = RecordList({});
  String avgVerticalOscillationString = "Loading ...";
  String sdevVerticalOscillationString = "Loading ...";

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
      var verticalOscillationRecords = records
          .where((value) =>
              value.db.verticalOscillation != null &&
              value.db.verticalOscillation > 0)
          .toList();

      if (verticalOscillationRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapVerticalOscillationChart(records: verticalOscillationRecords),
              Text('Only records where vertical oscillation is present are shown.'),
              Text('Swipe left/write to compare with other laps.'),
              Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgVerticalOscillationString),
                subtitle: Text("average vertical oscillation"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevVerticalOscillationString),
                subtitle: Text("standard deviation vertical oscillation"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(verticalOscillationRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No vertical oscillation data available."),
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

    double avg = await lap.avgVerticalOscillation;
    avgVerticalOscillationString = avg.toStringOrDashes(1) + " cm";

    double sdev = await lap.sdevVerticalOscillation;
    setState(() {
      sdevVerticalOscillationString = sdev.toStringOrDashes(2) + " cm";
    });
  }
}
