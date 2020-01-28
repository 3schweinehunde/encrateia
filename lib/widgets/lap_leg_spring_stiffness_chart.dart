import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';

class LapLegSpringStiffnessChart extends StatelessWidget {
  final List<Event> records;

  LapLegSpringStiffnessChart({this.records});

  @override
  Widget build(BuildContext context) {
    var nonZero = records
        .where((value) => value.db.legSpringStiffness != null && value.db.legSpringStiffness > 0)
        .toList();

    var offset = nonZero.first.db.distance.round();

    List<Series<dynamic, num>> data = [
      new Series<Event, int>(
        id: 'Leg Spring Stiffness',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.groundTime,
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
            'Leg Spring Stiffness (kN/m)',
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
