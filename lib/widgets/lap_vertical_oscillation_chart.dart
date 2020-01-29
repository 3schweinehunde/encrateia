import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';

class LapVerticalOscillationChart extends StatelessWidget {
  final List<Event> records;

  LapVerticalOscillationChart({this.records});

  @override
  Widget build(BuildContext context) {
    var nonZero = records
        .where((value) => value.db.verticalOscillation != null && value.db.verticalOscillation > 0)
        .toList();

    var offset = nonZero.first.db.distance.round();

    List<Series<dynamic, num>> data = [
      new Series<Event, int>(
        id: 'Vertical Oscillation',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.verticalOscillation,
        data: nonZero,
      )
    ];

    return new Container(
      height: 300,
      padding: EdgeInsets.all(2),
      child: LineChart(
        data,
        animate: false,
        primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: 5,
          ),
        ),
        behaviors: [
          ChartTitle(
            'Vertical Oscillation (cm)',
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.start,
            titleOutsideJustification: OutsideJustification.end,
          ),
          ChartTitle(
            'Distance (m)',
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
