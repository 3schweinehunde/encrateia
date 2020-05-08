import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/lap_charts/lap_ecor_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/num_utils.dart';

class LapEcorWidget extends StatefulWidget {
  final Lap lap;
  final Athlete athlete;

  LapEcorWidget({
    @required this.lap,
    @required this.athlete,
  });

  @override
  _LapEcorWidgetState createState() => _LapEcorWidgetState();
}

class _LapEcorWidgetState extends State<LapEcorWidget> {
  List<Event> records = [];
  Weight weight;
  String weightString;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (records.length > 0) {
      var powerRecords = records
          .where((value) =>
              value.db.power != null &&
              value.db.power > 100 &&
              value.db.speed != null &&
              value.db.speed >= 1)
          .toList();

      if (powerRecords.length > 0) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: EdgeInsets.only(left: 25),
            children: <Widget>[
              LapEcorChart(
                records: powerRecords,
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
    records = await widget.lap.records;
    weight = await Weight.getBy(
      athletesId: widget.athlete.db.id,
      date: widget.lap.db.startTime,
    );
    weightString = weight.db.value.toStringOrDashes(2) + " kg";
    setState(() {});
  }
}
