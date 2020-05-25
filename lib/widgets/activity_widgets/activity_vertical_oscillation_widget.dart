import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityVerticalOscillationWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityVerticalOscillationWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  _ActivityVerticalOscillationWidgetState createState() =>
      _ActivityVerticalOscillationWidgetState();
}

class _ActivityVerticalOscillationWidgetState
    extends State<ActivityVerticalOscillationWidget> {
  var records = RecordList(<Event>[]);
  String avgVerticalOscillationString = "Loading ...";
  String sdevVerticalOscillationString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerRecords = records
          .where((value) => value.db.verticalOscillation != null)
          .toList();

      if (powerRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityVerticalOscillationChart(
                records: RecordList(powerRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'vertical oscillation is present are shown.'),
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
                title: Text(powerRecords.length.toString()),
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
    Activity activity = widget.activity;
    records = RecordList(await activity.records);
    avgVerticalOscillationString =
        activity.db.avgVerticalOscillation.toStringOrDashes(1) + " cm";
    sdevVerticalOscillationString =
        activity.db.sdevVerticalOscillation.toStringOrDashes(2) + " cm";
    setState(() {});
  }
}
