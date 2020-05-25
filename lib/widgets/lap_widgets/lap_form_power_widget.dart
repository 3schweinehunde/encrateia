import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_form_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/event.dart';

class LapFormPowerWidget extends StatefulWidget {
  final Lap lap;

  LapFormPowerWidget({this.lap});

  @override
  _LapFormPowerWidgetState createState() => _LapFormPowerWidgetState();
}

class _LapFormPowerWidgetState extends State<LapFormPowerWidget> {
  var records = RecordList(<Event>[]);
  String avgFormPowerString = "Loading ...";
  String sdevFormPowerString = "Loading ...";

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
      var formPowerRecords = records
          .where(
              (value) => value.db.formPower != null && value.db.formPower > 0)
          .toList();

      if (formPowerRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapFormPowerChart(records: RecordList(formPowerRecords)),
              Text('Only records where 0 W < form power < 200 W are shown.'),
              Text('Swipe left/write to compare with other laps.'),
              Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgFormPowerString),
                subtitle: Text("average form power"),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevFormPowerString),
                subtitle: Text("standard deviation form power"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(formPowerRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No form power data available."),
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

    double avg = await lap.avgFormPower;
    avgFormPowerString = avg.toStringOrDashes(1) + " W";

    double sdev = await lap.sdevFormPower;
    setState(() {
      sdevFormPowerString = sdev.toStringOrDashes(2) + " W";
    });
  }
}
