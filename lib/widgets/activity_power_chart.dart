import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/list_utils.dart';

class ActivityPowerChart extends StatelessWidget {
  final List<Event> records;
  final Activity activity;
  final colorArray = [
    MaterialPalette.white,
    MaterialPalette.gray.shade200,
  ];

  ActivityPowerChart({this.records, @required this.activity});

  @override
  Widget build(BuildContext context) {
    var nonZero = records.where((value) => value.db.power > 100);
    var recducedRecords = nonZero.everyNth(25).toList();

    List<Series<dynamic, num>> data = [
      new Series<Event, int>(
        id: 'Power',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Event record, _) => record.db.distance.round(),
        measureFn: (Event record, _) => record.db.power,
        data: recducedRecords,
      )
    ];

    return FutureBuilder<List<Lap>>(
      future: Lap.by(activity: activity),
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          var laps = snapshot.data;
          return Container(
            height: 300,
            child: LineChart(
              data,
              domainAxis: NumericAxisSpec(
                viewport: NumericExtents(0, nonZero.last.db.distance + 500),
                tickProviderSpec: BasicNumericTickProviderSpec(
                  desiredTickCount: 6,
                ),
              ),
              primaryMeasureAxis: NumericAxisSpec(
                tickProviderSpec: BasicNumericTickProviderSpec(
                    zeroBound: false,
                    dataIsInWholeNumbers: true,
                    desiredTickCount: 6),
              ),
              animate: false,
              layoutConfig: LayoutConfig(
                leftMarginSpec: MarginSpec.fixedPixel(60),
                topMarginSpec: MarginSpec.fixedPixel(20),
                rightMarginSpec: MarginSpec.fixedPixel(20),
                bottomMarginSpec: MarginSpec.fixedPixel(40),
              ),
              behaviors: [
                RangeAnnotation(rangeAnnotations(laps: laps)),
                ChartTitle(
                  'Power (W)',
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
              ],
            ),
          );
        } else {
          return Center(
            child: Text("Loading"),
          );
        }
      },
    );
  }

  rangeAnnotations({List<Lap> laps}) {
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
}
