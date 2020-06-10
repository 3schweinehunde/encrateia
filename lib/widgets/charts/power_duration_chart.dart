import 'package:encrateia/models/power_duration.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/plot_point.dart';

class PowerDurationChart extends StatelessWidget {
  const PowerDurationChart({this.records});

  final List<Event> records;

  @override
  Widget build(BuildContext context) {
    final PowerDuration powerDuration = PowerDuration(records: records);

    final List<Series<DoublePlotPoint, num>> data = <Series<DoublePlotPoint, num>>[
      Series<DoublePlotPoint, int>(
        id: 'Power Duration',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: powerDuration.asList(),
      )
    ];

    final StaticNumericTickProviderSpec staticTicks =
        StaticNumericTickProviderSpec(<TickSpec<int>>[
      TickSpec<int>(PowerDuration.scaled(seconds: 1), label: '1s'),
      TickSpec<int>(PowerDuration.scaled(seconds: 10), label: '10s'),
      TickSpec<int>(PowerDuration.scaled(seconds: 60), label: '1min'),
      TickSpec<int>(PowerDuration.scaled(seconds: 600), label: '10min'),
      TickSpec<int>(PowerDuration.scaled(seconds: 3600), label: '1h'),
    ]);

    final List<ChartTitle> chartTitles = <ChartTitle>[
      ChartTitle(
        'Power (W)',
        titleStyleSpec: const TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.start,
        titleOutsideJustification: OutsideJustification.end,
      ),
      ChartTitle(
        'Time',
        titleStyleSpec: const TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.bottom,
        titleOutsideJustification: OutsideJustification.end,
      ),
    ];

    return Container(
      height: 300,
      padding: const EdgeInsets.all(2),
      child: LineChart(
        data,
        defaultRenderer: LineRendererConfig<num>(
          includeArea: true,
        ),
        primaryMeasureAxis: const NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: true,
              desiredTickCount: 10,
              desiredMinTickCount: 6),
        ),
        domainAxis: NumericAxisSpec(tickProviderSpec: staticTicks),
        animate: false,
        behaviors: chartTitles,
      ),
    );
  }
}
