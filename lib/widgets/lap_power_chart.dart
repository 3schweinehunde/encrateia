import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapPowerChart extends StatelessWidget {
  final List<Event> records;

  LapPowerChart({this.records});

  @override
  Widget build(BuildContext context) {
    var nonZero = records
        .where((value) => value.db.power != null && value.db.power > 100)
        .toList();

    var offset = nonZero.first.db.distance.round();

    List<Series<dynamic, num>> data = [
       Series<Event, int>(
        id: 'Power',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.power,
        data: nonZero,
      )
    ];

    return  Container(
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
        behaviors: GraphUtils.axis(
          measureTitle: 'Power (W)',
        ),
      ),
    );
  }
}
