import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapHeartRateChart extends StatelessWidget {
  const LapHeartRateChart({
    this.records,
    this.heartRateZones,
  });

  final RecordList<Event> records;
  final List<HeartRateZone> heartRateZones;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.db.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Heart Rate',
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.heartRate,
        data: records,
      )
    ];

    return Container(
      height: 300,
      child: LineChart(
        data,
        primaryMeasureAxis: NumericAxisSpec(
          viewport: MyLineChart.determineViewport(
            heartRateZones: heartRateZones,
          ),
          tickProviderSpec: const BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: true,
              desiredTickCount: 6),
        ),
        animate: false,
        behaviors: [
          RangeAnnotation(
            GraphUtils.heartRateZoneAnnotations(
              heartRateZones: heartRateZones,
            ),
          ),
          ChartTitle(
            'Heart Rate (bpm)',
            titleStyleSpec: const TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
