import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapStrydCadenceChart extends StatelessWidget {
  final List<Event> records;

  LapStrydCadenceChart({this.records});

  @override
  Widget build(BuildContext context) {
    var offset = records.first.db.distance.round();

    List<Series<dynamic, num>> data = [
       Series<Event, int>(
        id: 'Stryd Cadence',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => 2 * record.db.strydCadence,
        data: records,
      )
    ];

    return  Container(
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
          measureTitle: 'Cadence (spm)',
        ),
      ),
    );
  }
}
