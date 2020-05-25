import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';

class LapFormPowerChart extends StatelessWidget {
  final RecordList<Event> records;

  LapFormPowerChart({this.records});

  @override
  Widget build(BuildContext context) {
    var offset = records.first.db.distance.round();

    List<Series<dynamic, num>> data = [
       Series<Event, int>(
        id: 'Form Power',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round() - offset,
        measureFn: (Event record, _) => record.db.formPower,
        data: records,
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
