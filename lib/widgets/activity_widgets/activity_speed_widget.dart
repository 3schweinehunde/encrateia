import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_speed_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivitySpeedWidget extends StatefulWidget {
  const ActivitySpeedWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivitySpeedWidgetState createState() => _ActivitySpeedWidgetState();
}

class _ActivitySpeedWidgetState extends State<ActivitySpeedWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgSpeedString = 'Loading ...';
  String avgSpeedByMeasurementsString = 'Loading ...';
  String avgSpeedByTimeString = 'Loading ...';
  String avgSpeedByDistanceString = 'Loading ...';
  String sdevSpeedString = 'Loading ...';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> paceRecords = records
          .where((Event value) => value.speed != null && value.speed > 0)
          .toList();

      if (paceRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivitySpeedChart(
                records: RecordList<Event>(paceRecords),
                activity: widget.activity,
                athlete: widget.athlete,
                minimum:
                    (widget.activity.avgSpeed - 3 * widget.activity.sdevSpeed) *
                        3.6,
                maximum:
                    (widget.activity.avgSpeed + 3 * widget.activity.sdevSpeed) *
                        3.6,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'speed > 0 m/s are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgSpeedString),
                subtitle: const Text('average speed from .fit-file'),
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgSpeedByMeasurementsString),
                subtitle: const Text('average speed by measurements'),
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgSpeedByTimeString),
                subtitle: const Text('average speed by time'),
              ),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgSpeedByDistanceString),
                subtitle: const Text('average speed by distance'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevSpeedString),
                subtitle: const Text('standard deviation speed'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(paceRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No speed data available.'),
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
    avgSpeedString = activity.avgSpeed != null
        ? (activity.avgSpeed * 3.6).toStringAsFixed(2) + 'km/h'
        : '- - -';
    avgSpeedByMeasurementsString = activity.avgSpeedByMeasurements != null
        ? (activity.avgSpeedByMeasurements * 3.6).toStringAsFixed(2) + 'km/h'
        : '- - -';
    avgSpeedByTimeString = activity.avgSpeedByTime != null
        ? (activity.avgSpeedByTime * 3.6).toStringAsFixed(2) + 'km/h'
        : '- - -';
    avgSpeedByDistanceString = activity.avgSpeedByDistance != null
        ? (activity.avgSpeedByDistance * 3.6).toStringAsFixed(2) + 'km/h'
        : '- - -';
    sdevSpeedString = (activity.sdevSpeed * 3.6).toStringAsFixed(2) + ' km/h';
    setState(() {});
  }
}
