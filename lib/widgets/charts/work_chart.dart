import 'package:encrateia/models/critical_power.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/plot_point.dart';

class WorkChart extends StatelessWidget {
  const WorkChart({this.records});

  final List<Event> records;

  @override
  Widget build(BuildContext context) {
    final CriticalPower criticalPower = CriticalPower(records: records);
    final CriticalPower workCurve = criticalPower.workify();

    final List<Series<DoublePlotPoint, num>> data = <Series<DoublePlotPoint, num>>[
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
      TickSpec<int>(1200, label: '20min'),
    ]);

    final List<ChartTitle> chartTitles = <ChartTitle>[
      ChartTitle(
        'Work (J)',
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
      ChartTitle(
        'Work diagram created with Encrateia https://encreteia.informatom.com',
        titleStyleSpec: const TextStyleSpec(fontSize: 10),
        behaviorPosition: BehaviorPosition.top,
        titleOutsideJustification: OutsideJustification.endDrawArea,
      ),
    ];

    return ListView(
      children: <Widget>[
        Container(
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
            domainAxis: const NumericAxisSpec(tickProviderSpec: staticTicks),
            animate: false,
            behaviors: chartTitles,
          ),
        ),
        ListTile(
          leading: MyIcon.power,
          title: Text(criticalPower.wPrime().toString()),
          subtitle: const Text('W\' (J)'),
        ),
        ListTile(
          leading: MyIcon.power,
          title: Text(criticalPower.pCrit().toString()),
          subtitle: const Text('Critical Power (W)'),
        ),
        ListTile(
          leading: MyIcon.power,
          title: Text(criticalPower.rSquared().toString()),
          subtitle: const Text('r²'),
        ),
      ],
    );
  }
}
