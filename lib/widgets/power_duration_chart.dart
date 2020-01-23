import 'package:encrateia/models/power_duration.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/plot_point.dart';

class PowerDurationChart extends StatelessWidget {
  final List<Event> records;

  PowerDurationChart({this.records});

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

    final staticTicks = <TickSpec<int>>[
      TickSpec(PowerDuration.scaled(seconds: 1), label: '1s'),
      TickSpec(PowerDuration.scaled(seconds: 10), label: '10s'),
      TickSpec(PowerDuration.scaled(seconds: 60), label: '1min'),
      TickSpec(PowerDuration.scaled(seconds: 600), label: '10min'),
      TickSpec(PowerDuration.scaled(seconds: 3600), label: '1h'),
    ];

    final chartTitles = [
      ChartTitle(
        'Power (W)',
        titleStyleSpec: TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.start,
        titleOutsideJustification: OutsideJustification.end,
      ),
      ChartTitle(
        'Time',
        titleStyleSpec: TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.bottom,
        titleOutsideJustification: OutsideJustification.end,
      ),
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
        domainAxis: NumericAxisSpec(
            tickProviderSpec: StaticNumericTickProviderSpec(staticTicks)),
        animate: false,
        behaviors: chartTitles,
      ),
    );
  }
}
