import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapPowerChart extends StatelessWidget {
  final List<Event> records;
  final List<PowerZone> powerZones;

  LapPowerChart({
    this.records,
    this.powerZones,
  });

  @override
  Widget build(BuildContext context) {
    var offset = records.first.db.distance.round();

    List<Series<dynamic, num>> data = [
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
          tickProviderSpec: BasicNumericTickProviderSpec(
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
            "Power (W)",
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
