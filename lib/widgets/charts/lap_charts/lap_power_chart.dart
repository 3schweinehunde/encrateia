import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapPowerChart extends StatelessWidget {
  const LapPowerChart({
    this.records,
    this.powerZones,
  });

  final RecordList<Event> records;
  final List<PowerZone> powerZones;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.db.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Power',
        colorFn: (_, __) => MaterialPalette.gray.shade700,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.power,
        data: records,
      )
    ];

    return Container(
      height: 300,
      child: LineChart(
        data,
        primaryMeasureAxis: NumericAxisSpec(
          viewport: MyLineChart.determineViewport(
            powerZones: powerZones,
          ),
          tickProviderSpec: const BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: true,
              desiredTickCount: 6),
        ),
        animate: false,
        behaviors: [
          RangeAnnotation(
            GraphUtils.powerZoneAnnotations(powerZones: powerZones),
          ),
          ChartTitle(
            'Power (W)',
            titleStyleSpec: const TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
