import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:flutter/cupertino.dart';

class MyLineChart extends LineChart {
  MyLineChart(
      {@required data,
      @required maxDomain,
      @required laps,
      powerZones,
      @required domainTitle,
      measureTitle,
      measureTickProviderSpec,
      domainTickProviderSpec})
      : super(
          data,
          domainAxis: NumericAxisSpec(
            viewport: NumericExtents(0, maxDomain + 500),
            tickProviderSpec: domainTickProviderSpec,
          ),
          primaryMeasureAxis: NumericAxisSpec(
            tickProviderSpec: measureTickProviderSpec,
          ),
          animate: false,
          layoutConfig: GraphUtils.layoutConfig,
          behaviors: [
            RangeAnnotation(
              GraphUtils.rangeAnnotations(laps: laps) +
              GraphUtils.zoneAnnotations(powerZones: powerZones),
            ),
            ChartTitle(
              domainTitle,
              titleStyleSpec: TextStyleSpec(fontSize: 13),
              behaviorPosition: BehaviorPosition.start,
              titleOutsideJustification: OutsideJustification.end,
            ),
            ChartTitle(
              measureTitle ?? 'Distance (m)',
              titleStyleSpec: TextStyleSpec(fontSize: 13),
              behaviorPosition: BehaviorPosition.bottom,
              titleOutsideJustification: OutsideJustification.end,
            ),
          ],
        );
}
