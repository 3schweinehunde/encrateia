import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/graph_utils.dart';

class LapFormPowerChart extends StatelessWidget {
  const LapFormPowerChart({
    required this.records,
    required this.minimum,
    required this.maximum,
  });

  final RecordList<Event> records;
  final double minimum;
  final double maximum;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance!.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Form Power',
        colorFn: (_, __) => Color.black,
        domainFn: (Event record, _) => record.distance!.round() - offset,
        measureFn: (Event record, _) => record.formPower,
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
        primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: const BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: true,
            desiredTickCount: 6,
          ),
          viewport: NumericExtents(minimum, maximum),
        ),
        animate: false,
        behaviors: GraphUtils.axis(
          measureTitle: 'Form Power (W)',
        ),
      ),
    );
  }
}
