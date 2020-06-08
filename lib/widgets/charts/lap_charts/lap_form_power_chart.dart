import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapFormPowerChart extends StatelessWidget {
  const LapFormPowerChart({this.records});

  final RecordList<Event> records;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
       Series<Event, int>(
        id: 'Form Power',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.distance.round() - offset,
        measureFn: (Event record, _) => record.formPower,
        data: records,
      )
    ];

    return  Container(
      height: 300,
      child: LineChart(
        data,
        primaryMeasureAxis: const NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: true,
            desiredTickCount: 6,
          ),
        ),
        animate: false,
        behaviors: GraphUtils.axis(
          measureTitle: 'Form Power (W)',
        ),
      ),
    );
  }
}
