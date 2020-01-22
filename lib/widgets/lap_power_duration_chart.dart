import 'package:encrateia/models/power_duration.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/plot_point.dart';

class LapPowerDurationChart extends StatelessWidget {
  final List<Event> records;

  LapPowerDurationChart({this.records});

  @override
  Widget build(BuildContext context) {
    var nonZero = records
        .where((value) => value.db.power != null && value.db.power > 100)
        .toList();
    PowerDuration powerDuration = PowerDuration(records: nonZero);

    List<Series<dynamic, num>> data = [
      new Series<PlotPoint, int>(
        id: 'Power Duration',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (PlotPoint record, _) => record.domain,
        measureFn: (PlotPoint record, _) => record.measure,
        data: powerDuration.asList(),
      )
    ];

    return new Container(
      height: 300,
      padding: EdgeInsets.all(2),
      child: LineChart(
        data,
        primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: true,
              desiredTickCount: 10,
              desiredMinTickCount: 6),
        ),
        animate: false,
        behaviors: [
          ChartTitle(
            'Power (W)',
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.start,
            titleOutsideJustification: OutsideJustification.end,
          ),
          ChartTitle(
            'Time (s)',
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
