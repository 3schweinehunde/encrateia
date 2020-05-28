import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_stryd_cadence_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityStrydCadenceWidget extends StatefulWidget {
  const ActivityStrydCadenceWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityStrydCadenceWidgetState createState() =>
      _ActivityStrydCadenceWidgetState();
}

class _ActivityStrydCadenceWidgetState
    extends State<ActivityStrydCadenceWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgStrydCadenceString = 'Loading ...';
  String sdevStrydCadenceString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) =>
              value.db.strydCadence != null && value.db.strydCadence > 0)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityStrydCadenceChart(
                records: RecordList<Event>(powerRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.db.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'cadence > 0 s/min are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgStrydCadenceString),
                subtitle: const Text('average cadence'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevStrydCadenceString),
                subtitle: const Text('standard deviation cadence'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(powerRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No cadence data available.'),
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
    avgStrydCadenceString =
        activity.db.avgStrydCadence.toStringOrDashes(1) + ' spm';
    sdevStrydCadenceString =
        activity.db.sdevStrydCadence.toStringOrDashes(2) + ' spm';
    setState(() {});
  }
}
