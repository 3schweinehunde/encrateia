import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapGroundTimeChart extends StatelessWidget {
  final List<Event> records;

  LapGroundTimeChart({this.records});

  @override
  Widget build(BuildContext context) {
    var nonZero = records
        .where(
            (value) => value.db.groundTime != null && value.db.groundTime > 0)
        .toList();

    var offset = nonZero.first.db.distance.round();

    List<Series<dynamic, num>> data = [
      new Series<Event, int>(
        id: 'Ground Time',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.groundTime,
        data: nonZero,
      )
    ];

    return new Container(
      height: 300,
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
        behaviors: GraphUtils.axis(
          measureTitle: 'Ground Time (ms)',
        ),
      ),
    );
  }
}
