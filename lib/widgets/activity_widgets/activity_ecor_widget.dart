import 'package:encrateia/models/weight.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/actitvity_charts/activity_ecor_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityEcorWidget extends StatefulWidget {
  final Activity activity;

  ActivityEcorWidget({this.activity});

  @override
  _ActivityEcorWidgetState createState() => _ActivityEcorWidgetState();
}

class _ActivityEcorWidgetState extends State<ActivityEcorWidget> {
  List<Event> records = [];
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
              value.db.speed != 0)
          .toList();

      if (ecorRecords.length > 0 && weight != null) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityEcorChart(
                records: ecorRecords,
                activity: widget.activity,
                weight: weight.db.value,
              ),
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
    Activity activity = widget.activity;
    records = await activity.records;
    weight = await activity.getWeight();
    weightString = weight.db.value.toStringOrDashes(2) + " kg";
    setState(() {});
  }
}
