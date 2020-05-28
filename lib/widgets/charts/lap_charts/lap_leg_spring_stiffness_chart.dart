import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapLegSpringStiffnessChart extends StatelessWidget {
  const LapLegSpringStiffnessChart({this.records});

  final RecordList<Event> records;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.db.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
       Series<Event, int>(
        id: 'Leg Spring Stiffness',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.groundTime,
        data: records,
      )
    ];

    return  Container(
      height: 300,
      child: LineChart(
        data,
        animate: false,
        primaryMeasureAxis: const NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: 5,
          ),
        ),
        behaviors: GraphUtils.axis(
          measureTitle: 'Leg Spring Stiffness (kN/m)',
        ),
      ),
    );
  }
}
