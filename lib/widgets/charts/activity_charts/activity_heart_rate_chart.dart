import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/heart_rate_zone.dart';
import '/models/lap.dart';
import '/models/plot_point.dart';
import '/models/record_list.dart';
import '/utils/enums.dart';
import '/utils/graph_utils.dart';
import '/utils/my_line_chart.dart';

class ActivityHeartRateChart extends StatelessWidget {
  const ActivityHeartRateChart({
    Key? key,
    required this.records,
    required this.activity,
    required this.athlete,
    this.heartRateZones,
  }) : super(key: key);

  final RecordList<Event> records;
  final Activity? activity;
  final Athlete? athlete;
  final List<HeartRateZone>? heartRateZones;

  @override
  Widget build(BuildContext context) {
    final List<IntPlotPoint> smoothedRecords = records.toIntDataPoints(
      attribute: LapIntAttr.heartRate,
      amount: athlete!.recordAggregationCount,
    );

    final List<Series<IntPlotPoint, int>> data = <Series<IntPlotPoint, int>>[
      Series<IntPlotPoint, int>(
        id: 'Heart Rate',
        colorFn: (_, __) => Color.black,
        domainFn: (IntPlotPoint point, _) => point.domain,
        measureFn: (IntPlotPoint point, _) => point.measure,
        data: smoothedRecords,
      )
    ];

    return FutureBuilder<List<Lap>>(
      future: activity!.laps,
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          final List<Lap> laps = snapshot.data!;
          return AspectRatio(
            aspectRatio:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1
                    : 2,
            child: MyLineChart(
              data: data,
              maxDomain: records.last.distance!,
              laps: laps,
              heartRateZones: heartRateZones,
              domainTitle: 'Heart Rate (bpm)',
              measureTickProviderSpec: const BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: true,
                  desiredTickCount: 6),
              domainTickProviderSpec:
                  const BasicNumericTickProviderSpec(desiredTickCount: 6),
            ),
          );
        } else {
          return GraphUtils.loadingContainer;
        }
      },
    );
  }
}
