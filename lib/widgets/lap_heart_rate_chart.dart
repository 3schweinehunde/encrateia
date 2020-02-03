import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapHeartRateChart extends StatelessWidget {
  final List<Event> records;

  LapHeartRateChart({this.records});

  @override
  Widget build(BuildContext context) {
    var nonZero = records.where((value) => value.db.heartRate > 0).toList();
    var offset = nonZero.first.db.distance.round();

    List<Series<dynamic, num>> data = [
      new Series<Event, int>(
        id: 'Heart Rate',
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.heartRate,
        data: nonZero,
      )
    ];

    return new Container(
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
          measureTitle: 'Heart Rate (bpm)',
        ),
      ),
    );
  }
}
