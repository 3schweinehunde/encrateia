import 'package:encrateia/models/lap.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;

class GraphUtils {
  static rangeAnnotations({List<Lap> laps}) {
    final colorArray = [
      MaterialPalette.white,
      MaterialPalette.gray.shade200,
    ];

    return [
      for (int index = 0; index < laps.length; index++)
        RangeAnnotationSegment(
          laps
                  .sublist(0, index + 1)
                  .map((lap) => lap.db.totalDistance)
                  .reduce((a, b) => a + b) -
              laps[index].db.totalDistance,
          laps
              .sublist(0, index + 1)
              .map((lap) => lap.db.totalDistance)
              .reduce((a, b) => a + b),
          RangeAnnotationAxisType.domain,
          color: colorArray[index % 2],
          endLabel: 'Lap ${laps[index].index}',
        )
    ];
  }

  static var layoutConfig = LayoutConfig(
    leftMarginSpec: MarginSpec.fixedPixel(60),
    topMarginSpec: MarginSpec.fixedPixel(20),
    rightMarginSpec: MarginSpec.fixedPixel(20),
    bottomMarginSpec: MarginSpec.fixedPixel(40),
  );

  static var loadingContainer = Container(
    height: 100,
    child: Center(child: Text("Loading")),
  );

  static axis({String measureTitle}) {
    return [
      ChartTitle(
        measureTitle,
        titleStyleSpec: TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.start,
        titleOutsideJustification: OutsideJustification.end,
      ),
      ChartTitle(
        'Distance (m)',
        titleStyleSpec: TextStyleSpec(fontSize: 13),
        behaviorPosition: BehaviorPosition.bottom,
        titleOutsideJustification: OutsideJustification.end,
      ),
    ];
  }

  static zoneAnnotations({List<PowerZone> powerZones}) {
    if (powerZones != null) {
      return [
        for (PowerZone powerZone in powerZones)
          RangeAnnotationSegment(
            powerZone.db.lowerLimit,
            powerZone.db.upperLimit,
            RangeAnnotationAxisType.measure,
            startLabel: powerZone.db.name,
            color: convertedColor(dbColor: powerZone.db.color),
          )
      ];
    } else
      return [];
  }

  static convertedColor({int dbColor}) {
    return Color(
      r: UI.Color(dbColor).red,
      g: UI.Color(dbColor).green,
      b: UI.Color(dbColor).blue,
      a: (UI.Color(dbColor).alpha / 2).round(),
    );
  }
}
