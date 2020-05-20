import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
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
              viewport: determineViewport(
                powerZones: powerZones,
                heartRateZones: heartRateZones,
              )),
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

  static determineViewport({List<PowerZone> powerZones, List<HeartRateZone> heartRateZones, }) {
    if (powerZones != null)
      return NumericExtents(
          powerZones
                  .map((PowerZone powerZone) => powerZone.db.lowerLimit)
                  .reduce(min) -
              5.0,
          powerZones
                  .map((PowerZone powerZone) => powerZone.db.upperLimit)
                  .reduce(max) +
              5.0);
    else if (heartRateZones != null)
      return NumericExtents(
          heartRateZones
              .map((HeartRateZone heartRateZone) => heartRateZone.db.lowerLimit)
              .reduce(min) -
              5.0,
          heartRateZones
              .map((HeartRateZone heartRateZone) => heartRateZone.db.upperLimit)
              .reduce(max) +
              5.0);
  }
}
