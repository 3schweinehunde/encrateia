import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/graph_utils.dart';

class LapLegSpringStiffnessChart extends StatelessWidget {
  const LapLegSpringStiffnessChart({
    Key? key,
    required this.records,
    required this.minimum,
    required this.maximum,
  }) : super(key: key);

  final RecordList<Event> records;
  final double minimum;
  final double maximum;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance!.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Leg Spring Stiffness',
        colorFn: (_, __) => Color.black,
        domainFn: (Event record, _) => record.distance!.round() - offset,
        measureFn: (Event record, _) => record.legSpringStiffness,
        data: records,
      )
    ];

    return AspectRatio(
      aspectRatio:
          MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
      child: LineChart(
        data,
        animate: false,
        defaultRenderer: LineRendererConfig<num>(
          includeArea: true,
          strokeWidthPx: 1,
        ),
        primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: const BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: 5,
          ),
          viewport: NumericExtents(minimum, maximum),
        ),
        behaviors: GraphUtils.axis(
          measureTitle: 'Leg Spring Stiffness (kN/m)',
        ),
      ),
    );
  }
}
