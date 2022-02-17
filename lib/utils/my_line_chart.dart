import 'dart:math';

import 'package:charts_common/common.dart' as common show Series;
import 'package:charts_flutter/flutter.dart';

import '/models/heart_rate_zone.dart';
import '/models/lap.dart';
import '/models/power_zone.dart';
import '/utils/graph_utils.dart';

class MyLineChart extends LineChart {
  MyLineChart({
    required List<common.Series<dynamic, num?>> data,
    required double maxDomain,
    required List<Lap> laps,
    List<PowerZone>? powerZones,
    List<HeartRateZone>? heartRateZones,
    required String domainTitle,
    String? measureTitle,
    NumericTickProviderSpec? measureTickProviderSpec,
    NumericTickProviderSpec? domainTickProviderSpec,
    double? minimum,
    double? maximum,
    bool? flipVerticalAxis,
  }) : super(
          data as List<Series<dynamic, num>>,
          defaultRenderer: LineRendererConfig<num>(
            includeArea: true,
            strokeWidthPx: 1,
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
          flipVerticalAxis: flipVerticalAxis ?? false,
          layoutConfig: GraphUtils.layoutConfig,
          behaviors: <ChartBehavior<num>>[
            PanAndZoomBehavior<num>(),
            RangeAnnotation<num>(
              GraphUtils.rangeAnnotations(laps: laps) +
                  GraphUtils.powerZoneAnnotations(
                    powerZones: powerZones,
                  ) +
                  GraphUtils.heartRateZoneAnnotations(
                    heartRateZones: heartRateZones,
                  ) as List<AnnotationSegment<Object>>,
            ),
            ChartTitle<num>(
              domainTitle,
              titleStyleSpec: const TextStyleSpec(fontSize: 13),
              behaviorPosition: BehaviorPosition.start,
              titleOutsideJustification: OutsideJustification.end,
            ),
            ChartTitle<num>(
              measureTitle ?? 'Distance (m)',
              titleStyleSpec: const TextStyleSpec(fontSize: 13),
              behaviorPosition: BehaviorPosition.bottom,
              titleOutsideJustification: OutsideJustification.end,
            ),
            ChartTitle<num>(
              '$domainTitle Diagram created with Encrateia https://encreteia.informatom.com',
              behaviorPosition: BehaviorPosition.top,
              titleOutsideJustification: OutsideJustification.endDrawArea,
              titleStyleSpec: const TextStyleSpec(fontSize: 10),
            )
          ],
        );

  static NumericExtents? determineViewport({
    List<PowerZone>? powerZones,
    List<HeartRateZone>? heartRateZones,
    double? minimum,
    double? maximum,
  }) {
    if (powerZones != null) {
      return NumericExtents(
          powerZones
                  .map((PowerZone powerZone) => powerZone.lowerLimit)
                  .reduce(min)! *
              0.9,
          powerZones
                  .map((PowerZone powerZone) => powerZone.upperLimit)
                  .reduce(max)! *
              1.1);
    } else if (heartRateZones != null) {
      return NumericExtents(
          heartRateZones
                  .map(
                      (HeartRateZone heartRateZone) => heartRateZone.lowerLimit)
                  .reduce(min)! *
              0.9,
          heartRateZones
                  .map(
                      (HeartRateZone heartRateZone) => heartRateZone.upperLimit)
                  .reduce(max)! *
              1.1);
    } else if (minimum != null) {
      return NumericExtents(minimum, maximum!);
    } else {
      return null;
    }
  }
}
