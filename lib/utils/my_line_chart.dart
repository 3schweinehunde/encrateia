import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

class MyLineChart extends LineChart {
  MyLineChart({
    @required data,
    @required maxDomain,
    @required laps,
    powerZones,
    heartRateZones,
    @required domainTitle,
    measureTitle,
    measureTickProviderSpec,
    domainTickProviderSpec,
  }) : super(
          data,
          domainAxis: NumericAxisSpec(
            viewport: NumericExtents(0, maxDomain + 500),
            tickProviderSpec: domainTickProviderSpec,
          ),
          primaryMeasureAxis: NumericAxisSpec(
            tickProviderSpec: measureTickProviderSpec,
            viewport: (powerZones != null)
                ? NumericExtents(
                    calcyMin(powerZones),
                    calcyMax(powerZones),
                  )
                : null,
          ),
          animate: false,
          layoutConfig: GraphUtils.layoutConfig,
          behaviors: [
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

  static num calcyMin(List<PowerZone> powerZones) =>
      powerZones
          .map((PowerZone powerZone) => powerZone.db.lowerLimit)
          .reduce(min) -
      5.0;

  static num calcyMax(List<PowerZone> powerZones) =>
      powerZones
          .map((PowerZone powerZone) => powerZone.db.upperLimit)
          .reduce(max) +
      5.0;
}
