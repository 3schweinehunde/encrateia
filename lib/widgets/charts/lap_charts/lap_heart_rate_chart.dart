import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapHeartRateChart extends StatelessWidget {
  final List<Event> records;
  final List<HeartRateZone> heartRateZones;

  LapHeartRateChart({
    this.records,
    this.heartRateZones,
  });

  @override
  Widget build(BuildContext context) {
    var offset = records.first.db.distance.round();

    List<Series<dynamic, num>> data = [
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
          tickProviderSpec: BasicNumericTickProviderSpec(
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
            "Heart Rate (bpm)",
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
