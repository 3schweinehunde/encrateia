import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import '/models/event.dart';
import '/models/plot_point.dart';
import '/models/power_duration.dart';

class FtpChart extends StatelessWidget {
  const FtpChart({Key? key, this.records}) : super(key: key);

  final List<Event>? records;

  @override
  Widget build(BuildContext context) {
    final PowerDuration powerDuration = PowerDuration(records: records!);
    final PowerDuration ftpCurve = powerDuration.normalize();

    final List<Series<DoublePlotPoint, num>> data =
        <Series<DoublePlotPoint, num>>[
      Series<DoublePlotPoint, int>(
        id: 'Power Duration',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: ftpCurve.asList(),
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

    final List<ChartTitle<num>> chartTitles = <ChartTitle<num>>[
      ChartTitle<num>(
        'normalized FTP Power (W)',
        titleStyleSpec: const TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.start,
        titleOutsideJustification: OutsideJustification.end,
      ),
      ChartTitle<num>(
        'Time',
        titleStyleSpec: const TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.bottom,
        titleOutsideJustification: OutsideJustification.end,
      ),
      ChartTitle<num>(
        'FTP diagram created with Encrateia https://encreteia.informatom.com',
        titleStyleSpec: const TextStyleSpec(fontSize: 10),
        behaviorPosition: BehaviorPosition.top,
        titleOutsideJustification: OutsideJustification.endDrawArea,
      ),
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
