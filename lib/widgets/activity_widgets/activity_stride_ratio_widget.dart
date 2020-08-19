import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_stride_ratio_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityStrideRatioWidget extends StatefulWidget {
  const ActivityStrideRatioWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityStrideRatioWidgetState createState() =>
      _ActivityStrideRatioWidgetState();
}

class _ActivityStrideRatioWidgetState extends State<ActivityStrideRatioWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> strideRatioRecords = records
          .where((Event value) =>
              value.strydCadence != null &&
              value.verticalOscillation != null &&
              value.verticalOscillation != 0)
          .toList();

      if (strideRatioRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityStrideRatioChart(
                records: RecordList<Event>(strideRatioRecords),
                activity: widget.activity,
                athlete: widget.athlete,
              ),
              const Text('stride ratio = stride length (cm) / vertical oscillation'
                  ' (cm)'),
              const Text('stride length (cm) = 10 000 / 6 * speed (km/h) / cadence '
                  '(strides/min)'),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'cadence is present and vertical oscillation > 0 mm are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.strideRatio,
                title: PQText(value: widget.activity.avgStrideRatio, pq: PQ.double),
                subtitle: const Text('average stride ratio'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.activity.sdevStrideRatio, pq: PQ.double),
                subtitle: const Text('standard deviation stride ratio '),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: strideRatioRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No stride ratio data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    setState(() => loading = false);
  }
}
