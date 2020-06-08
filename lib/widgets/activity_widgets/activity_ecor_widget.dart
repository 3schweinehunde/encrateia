import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_ecor_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityEcorWidget extends StatefulWidget {
  const ActivityEcorWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityEcorWidgetState createState() => _ActivityEcorWidgetState();
}

class _ActivityEcorWidgetState extends State<ActivityEcorWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  Weight weight;
  String weightString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> ecorRecords = records
          .where((Event value) =>
              value.power != null &&
              value.power > 100 &&
              value.speed != null &&
              value.speed >= 1)
          .toList();

      if (ecorRecords.isNotEmpty && ecorRecords != null) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityEcorChart(
                records: RecordList<Event>(ecorRecords),
                activity: widget.activity,
                athlete: widget.athlete,
                weight: weight.value,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 0 W and speed > 1 m/s are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.power,
                title: Text((widget.activity.weight != null)
                    ? (widget.activity.getAttribute(ActivityAttr.ecor)
                                as double)
                            .toStringAsFixed(3) +
                        ' kJ / kg / km'
                    : 'not available'),
                subtitle: const Text('ecor (Energy cost of running)'),
              ),
              ListTile(
                leading: MyIcon.weight,
                title: Text(weightString),
                subtitle: const Text('weight'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(ecorRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No ecor data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity.records);
    weight = await Weight.getBy(
      athletesId: widget.athlete.id,
      date: widget.activity.db.timeCreated,
    );
    widget.activity.weight = weight.value;
    weightString = weight.value.toStringOrDashes(2) + ' kg';
    setState(() {});
  }
}
