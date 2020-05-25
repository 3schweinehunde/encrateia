import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_form_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityFormPowerWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityFormPowerWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  _ActivityFormPowerWidgetState createState() =>
      _ActivityFormPowerWidgetState();
}

class _ActivityFormPowerWidgetState extends State<ActivityFormPowerWidget> {
  var records = RecordList(<Event>[]);
  String avgFormPowerString = "Loading ...";
  String sdevFormPowerString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var formPowerRecords = records
          .where((value) =>
              value.db.formPower != null &&
              value.db.formPower > 0 &&
              value.db.formPower < 200)
          .toList();

      if (formPowerRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityFormPowerChart(
                records: RecordList(formPowerRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  '0 W < form power < 200 W are shown.'),
              Divider(),
              ListTile(
                leading: MyIcon.formPower,
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
    Activity activity = widget.activity;
    records = RecordList(await activity.records);
    avgFormPowerString = activity.db.avgFormPower.toStringOrDashes(1) + " W";
    sdevFormPowerString = activity.db.sdevFormPower.toStringOrDashes(2) + " W";
    setState(() {});
  }
}
