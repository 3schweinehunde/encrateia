import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:flutter/material.dart';

class LapPowerChart extends StatelessWidget {
  const LapPowerChart({
    @required this.records,
    this.powerZones,
  });

  final RecordList<Event> records;
  final List<PowerZone> powerZones;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Power',
        colorFn: (_, __) => Color.black,
        domainFn: (Event record, _) => record.distance.round() - offset,
        measureFn: (Event record, _) => record.power,
        data: records,
      )
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
        primaryMeasureAxis: NumericAxisSpec(
          viewport: MyLineChart.determineViewport(
            powerZones: powerZones,
          ),
          tickProviderSpec: const BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: true,
              desiredTickCount: 6),
        ),
        animate: false,
        behaviors: <ChartBehavior<num>>[
              RangeAnnotation<num>(
                GraphUtils.powerZoneAnnotations(powerZones: powerZones),
              ),
            ] +
            GraphUtils.axis(
              measureTitle: 'Power (W)',
            ),
      ),
    );
  }
}
