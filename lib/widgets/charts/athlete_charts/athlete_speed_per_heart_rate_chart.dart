import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class AthleteSpeedPerHeartRateChart extends StatelessWidget {
  final List<Activity> activities;

  AthleteSpeedPerHeartRateChart({@required this.activities});

  @override
  Widget build(BuildContext context) {
    var nonZero = activities.where((value) => value.db.avgSpeed > 0).toList();

    var data = [
      new Series<Activity, DateTime>(
        id: 'Average Speed',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) =>
        (100 * activity.db.avgSpeed / activity.db.avgHeartRate),
        data: nonZero,
      )
    ];

    return new Container(
      height: 300,
      child: TimeSeriesChart(
        data,
        animate: false,
        primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: 6,
          ),
        ),
        behaviors: [
          ChartTitle(
            'Speed per Heart Rate (km/h / 100 bpm)',
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.start,
            titleOutsideJustification: OutsideJustification.end,
          ),
          ChartTitle(
            'Date',
            titleStyleSpec: TextStyleSpec(fontSize: 13),
            behaviorPosition: BehaviorPosition.bottom,
            titleOutsideJustification: OutsideJustification.end,
          ),
        ],
      ),
    );
  }
}
