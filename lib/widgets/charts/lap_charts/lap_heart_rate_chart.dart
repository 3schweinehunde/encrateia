import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:charts_common/common.dart' as common show ChartBehavior;

class LapHeartRateChart extends StatelessWidget {
  const LapHeartRateChart({
    @required this.records,
    this.heartRateZones,
  });

  final RecordList<Event> records;
  final List<HeartRateZone> heartRateZones;

  @override
  Widget build(BuildContext context) {
    final int offset = records.first.distance.round();

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Heart Rate',
        colorFn: (_, __) => MaterialPalette.black,
        domainFn: (Event record, _) => record.distance.round() - offset,
        measureFn: (Event record, _) => record.heartRate,
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
            heartRateZones: heartRateZones,
          ),
          tickProviderSpec: const BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: true,
              desiredTickCount: 6),
        ),
        animate: false,
        behaviors: <ChartBehavior<common.ChartBehavior<dynamic>>>[
              RangeAnnotation(
                GraphUtils.heartRateZoneAnnotations(
                    heartRateZones: heartRateZones),
              ),
            ] +
            GraphUtils.axis(
              measureTitle: 'Heart Rate (bpm)',
            ),
      ),
    );
  }
}
