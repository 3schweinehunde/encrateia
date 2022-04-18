import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import '/models/critical_power.dart';
import '/models/event.dart';
import '/models/plot_point.dart';
import '/utils/icon_utils.dart';

class WorkChart extends StatelessWidget {
  const WorkChart({Key? key, this.records}) : super(key: key);

  final List<Event>? records;

  @override
  Widget build(BuildContext context) {
    final CriticalPower criticalPower = CriticalPower(records: records!);
    final CriticalPower workCurve = criticalPower.workify();

    final List<Series<DoublePlotPoint, num>> data =
        <Series<DoublePlotPoint, num>>[
      Series<DoublePlotPoint, int>(
        id: 'Work',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: workCurve.asWorkList(),
      )
    ];

    const StaticNumericTickProviderSpec staticTicks =
        StaticNumericTickProviderSpec(<TickSpec<int>>[
      TickSpec<int>(60, label: '1min'),
      TickSpec<int>(600, label: '10min'),
      TickSpec<int>(3600, label: '60min'),
    ]);

    final List<ChartTitle<num>> chartTitles = <ChartTitle<num>>[
      ChartTitle<num>(
        'Work (J)',
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
        'Work diagram created with Encrateia https://encreteia.informatom.com',
        titleStyleSpec: const TextStyleSpec(fontSize: 10),
        behaviorPosition: BehaviorPosition.top,
        titleOutsideJustification: OutsideJustification.endDrawArea,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AspectRatio(
          aspectRatio:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 1
                  : 2,
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
            domainAxis: const NumericAxisSpec(tickProviderSpec: staticTicks),
            animate: false,
            behaviors: chartTitles,
          ),
        ),
        ListTile(
          leading: MyIcon.power,
          title: Text(criticalPower.wPrime().toStringAsFixed(2)),
          subtitle: const Text('W\' (J)'),
        ),
        ListTile(
          leading: MyIcon.power,
          title: Text(criticalPower.pCrit().toStringAsFixed(2)),
          subtitle: const Text('Critical Power (W)'),
        ),
        ListTile(
          leading: MyIcon.power,
          title: Text(criticalPower.rSquared().toStringAsPrecision(3)),
          subtitle: const Text('r²'),
        ),
      ],
    );
  }
}
