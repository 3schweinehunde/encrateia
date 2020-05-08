import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';

class LapEcorChart extends StatelessWidget {
  final List<Event> records;
  final double weight;

  LapEcorChart({
    this.records,
    @required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    var offset = records.first.db.distance.round();

    List<Series<dynamic, num>> data = [
      Series<Event, int>(
        id: 'Ecor',
        colorFn: (_, __) => MaterialPalette.gray.shade700,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) =>
            record.db.power / record.db.speed / weight,
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
              dataIsInWholeNumbers: false,
              desiredTickCount: 6),
        ),
        animate: false,
        behaviors: [
          ChartTitle(
            "Ecor (W s/kg m)",
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
