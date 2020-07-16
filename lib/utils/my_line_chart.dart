import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:charts_common/common.dart' as common show Series, ChartBehavior;

class MyLineChart extends LineChart {
  MyLineChart(
      {@required List<common.Series<dynamic, dynamic>> data,
      @required double maxDomain,
      @required List<Lap> laps,
      List<PowerZone> powerZones,
      List<HeartRateZone> heartRateZones,
      @required String domainTitle,
      String measureTitle,
      NumericTickProviderSpec measureTickProviderSpec,
      NumericTickProviderSpec domainTickProviderSpec,
      double minimum,
      double maximum})
      : super(
          data,
          defaultRenderer: LineRendererConfig<num>(
            includeArea: true,
          ),
          domainAxis: NumericAxisSpec(
            viewport: NumericExtents(0, maxDomain + 500),
            tickProviderSpec: domainTickProviderSpec,
          ),
          primaryMeasureAxis: NumericAxisSpec(
              tickProviderSpec: measureTickProviderSpec,
              viewport: determineViewport(
                powerZones: powerZones,
                heartRateZones: heartRateZones,
                minimum: minimum,
                maximum: maximum,
              )),
          animate: false,
          layoutConfig: GraphUtils.layoutConfig,
          behaviors: <ChartBehavior<common.ChartBehavior<dynamic>>>[
            PanAndZoomBehavior(),
            RangeAnnotation(
              GraphUtils.rangeAnnotations(laps: laps) +
                  GraphUtils.powerZoneAnnotations(
                    powerZones: powerZones,
                  ) +
                  GraphUtils.heartRateZoneAnnotations(
                    heartRateZones: heartRateZones,
                  ),
            ),
            ChartTitle(
              domainTitle,
              titleStyleSpec: const TextStyleSpec(fontSize: 13),
              behaviorPosition: BehaviorPosition.start,
              titleOutsideJustification: OutsideJustification.end,
            ),
            ChartTitle(
              measureTitle ?? 'Distance (m)',
              titleStyleSpec: const TextStyleSpec(fontSize: 13),
              behaviorPosition: BehaviorPosition.bottom,
              titleOutsideJustification: OutsideJustification.end,
            ),
            ChartTitle(
              '$domainTitle Diagram created with Encrateia https://encreteia.informatom.com',
              behaviorPosition: BehaviorPosition.top,
              titleOutsideJustification: OutsideJustification.endDrawArea,
              titleStyleSpec: const TextStyleSpec(fontSize: 10),
            )
          ],
        );

  static NumericExtents determineViewport({
    List<PowerZone> powerZones,
    List<HeartRateZone> heartRateZones,
    double minimum,
    double maximum,
  }) {
    if (powerZones != null)
      return NumericExtents(
          powerZones
                  .map((PowerZone powerZone) => powerZone.lowerLimit)
                  .reduce(min) *
              0.9,
          powerZones
                  .map((PowerZone powerZone) => powerZone.upperLimit)
                  .reduce(max) *
              1.1);
    else if (heartRateZones != null)
      return NumericExtents(
          heartRateZones
                  .map(
                      (HeartRateZone heartRateZone) => heartRateZone.lowerLimit)
                  .reduce(min) *
              0.9,
          heartRateZones
                  .map(
                      (HeartRateZone heartRateZone) => heartRateZone.upperLimit)
                  .reduce(max) *
              1.1);
    else if (minimum != null)
      return NumericExtents(minimum, maximum);
    else
      return null;
  }
}
