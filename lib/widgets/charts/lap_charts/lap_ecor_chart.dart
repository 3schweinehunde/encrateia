import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/graph_utils.dart';

class LapEcorChart extends StatelessWidget {
  const LapEcorChart({
    Key? key,
    required this.records,
    required this.weight,
  }) : super(key: key);

  final RecordList<Event> records;
  final double? weight;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance!.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Ecor',
        colorFn: (_, __) => MaterialPalette.black,
        domainFn: (Event record, _) => record.distance!.round() - offset,
        measureFn: (Event record, _) => record.power! / record.speed! / weight!,
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
