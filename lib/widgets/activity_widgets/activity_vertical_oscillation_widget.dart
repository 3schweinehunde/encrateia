import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_vertical_oscillation_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityVerticalOscillationWidget extends StatefulWidget {
  const ActivityVerticalOscillationWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityVerticalOscillationWidgetState createState() =>
      _ActivityVerticalOscillationWidgetState();
}

class _ActivityVerticalOscillationWidgetState
    extends State<ActivityVerticalOscillationWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgVerticalOscillationString = 'Loading ...';
  String sdevVerticalOscillationString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) => value.verticalOscillation != null)
          .toList();

      if (powerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityVerticalOscillationChart(
                records: RecordList<Event>(powerRecords),
                activity: widget.activity,
                athlete: widget.athlete,
                minimum: widget.activity.avgVerticalOscillation / 1.25,
                maximum: widget.activity.avgVerticalOscillation * 1.25,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'vertical oscillation is present are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgVerticalOscillationString),
                subtitle: const Text('average vertical oscillation'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevVerticalOscillationString),
                subtitle: const Text('standard deviation vertical oscillation'),
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
          child: Text('No vertical oscillation data available.'),
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
    avgVerticalOscillationString =
        activity.avgVerticalOscillation.toStringOrDashes(1) + ' cm';
    sdevVerticalOscillationString =
        activity.sdevVerticalOscillation.toStringOrDashes(2) + ' cm';
    setState(() {});
  }
}
