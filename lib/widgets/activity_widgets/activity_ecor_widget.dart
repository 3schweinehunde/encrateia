import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/weight.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_ecor_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityEcorWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityEcorWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  _ActivityEcorWidgetState createState() => _ActivityEcorWidgetState();
}

class _ActivityEcorWidgetState extends State<ActivityEcorWidget> {
  var records = RecordList([]);
  Weight weight;
  String weightString = "Loading ...";

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var ecorRecords = records
          .where((value) =>
              value.db.power != null &&
              value.db.power > 100 &&
              value.db.speed != null &&
              value.db.speed >= 1)
          .toList();

      if (ecorRecords.length > 0 && ecorRecords != null) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: [
              ActivityEcorChart(
                records: ecorRecords,
                activity: widget.activity,
                athlete: widget.athlete,
                weight: weight.db.value,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 0 W and speed > 1 m/s are shown.'),
              Divider(),
              ListTile(
                leading: MyIcon.weight,
                title: Text(weightString),
                subtitle: Text("weight"),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(ecorRecords.length.toString()),
                subtitle: Text("number of measurements"),
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text("No ecor data available."),
        );
      }
    } else {
      return Center(
        child: Text("Loading"),
      );
    }
  }

  getData() async {
    records = RecordList(await widget.activity.records);
    weight = await Weight.getBy(
      athletesId: widget.athlete.db.id,
      date: widget.activity.db.timeCreated,
    );
    weightString = weight.db.value.toStringOrDashes(2) + " kg";
    setState(() {});
  }
}
