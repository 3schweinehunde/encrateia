import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_form_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityFormPowerWidget extends StatefulWidget {
  const ActivityFormPowerWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityFormPowerWidgetState createState() =>
      _ActivityFormPowerWidgetState();
}

class _ActivityFormPowerWidgetState extends State<ActivityFormPowerWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgFormPowerString = 'Loading ...';
  String sdevFormPowerString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> formPowerRecords = records
          .where((Event value) =>
              value.formPower != null &&
              value.formPower > 0 &&
              value.formPower < 200)
          .toList();

      if (formPowerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityFormPowerChart(
                records: RecordList<Event>(formPowerRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  '0 W < form power < 200 W are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.formPower,
                title: Text(avgFormPowerString),
                subtitle: const Text('average form power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevFormPowerString),
                subtitle: const Text('standard deviation form power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(formPowerRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No form power data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    avgFormPowerString = activity.db.avgFormPower.toStringOrDashes(1) + ' W';
    sdevFormPowerString = activity.db.sdevFormPower.toStringOrDashes(2) + ' W';
    setState(() {});
  }
}
