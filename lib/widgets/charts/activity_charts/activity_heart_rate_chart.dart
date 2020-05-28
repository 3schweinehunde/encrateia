import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:encrateia/utils/enums.dart';

class ActivityHeartRateChart extends StatelessWidget {
  const ActivityHeartRateChart({
    @required this.records,
    @required this.activity,
    @required this.athlete,
    this.heartRateZones,
  });

  final RecordList<Event> records;
  final Activity activity;
  final Athlete athlete;
  final List<HeartRateZone> heartRateZones;

  @override
  Widget build(BuildContext context) {
    final List<IntPlotPoint> smoothedRecords = records.toIntDataPoints(
      attribute: LapIntAttr.heartRate,
      amount: athlete.db.recordAggregationCount,
    );

    final List<Series<IntPlotPoint, int>> data = <Series<IntPlotPoint, int>>[
      Series<IntPlotPoint, int>(
        id: 'Heart Rate',
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        domainFn: (IntPlotPoint point, _) => point.domain,
        measureFn: (IntPlotPoint point, _) => point.measure,
        data: smoothedRecords,
      )
    ];

    return FutureBuilder<List<Lap>>(
      future: Lap.all(activity: activity),
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          final List<Lap> laps = snapshot.data;
          return Container(
            height: 300,
            child: MyLineChart(
              data: data,
              maxDomain: records.last.db.distance,
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
        } else
          return GraphUtils.loadingContainer;
      },
    );
  }
}
