import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';

class LapEcorChart extends StatelessWidget {
  const LapEcorChart({
    @required this.records,
    @required this.weight,
  });

  final RecordList<Event> records;
  final double weight;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Ecor',
        colorFn: (_, __) => MaterialPalette.black,
        domainFn: (Event record, _) => record.distance.round() - offset,
        measureFn: (Event record, _) => record.power / record.speed / weight,
        data: records,
      )
    ];

    return AspectRatio(
      aspectRatio:
          MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
      child: LineChart(
        data,
        defaultRenderer: LineRendererConfig<num>(
          includeArea: true,
          strokeWidthPx: 1,
        ),
        primaryMeasureAxis: const NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: false,
              desiredTickCount: 6),
        ),
        animate: false,
        behaviors: GraphUtils.axis(
          measureTitle: 'Ecor (kJ/kg/km)',
        ),
      ),
    );
  }
}
