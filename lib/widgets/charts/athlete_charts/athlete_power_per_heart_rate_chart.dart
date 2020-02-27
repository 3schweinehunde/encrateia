import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/utils/enums.dart';

class AthletePowerPerHeartRateChart extends StatelessWidget {
  final List<Activity> activities;

  AthletePowerPerHeartRateChart({@required this.activities});

  @override
  Widget build(BuildContext context) {
    int xAxesDays = 60;

    var nonZeroActivities = activities
        .where((value) =>
            value.db.avgPower != null &&
            value.db.avgPower > 0 &&
            value.db.avgHeartRate != null &&
            value.db.avgHeartRate > 0)
        .toList();

    ActivityList(activities: nonZeroActivities).enrichGlidingAverage(
      quantity: ActivityAttr.avgPowerPerHeartRate,
      fullDecay: 30,
    );

    var nonZeroDateLimited = nonZeroActivities
        .where((activity) =>
            DateTime.now().difference(activity.db.timeCreated).inDays <
            xAxesDays)
        .toList();

    var data = [
      Series<Activity, DateTime>(
        id: 'Average power per heart rate',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) =>
            (activity.db.avgPower / activity.db.avgHeartRate),
        data: nonZeroDateLimited,
      ),
      Series<Activity, DateTime>(
        id: 'Gliding average power per heart rate',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) =>
            activity.glidingAvgPowerPerHeartRate,
        data: nonZeroDateLimited,
      )..setAttribute(rendererIdKey, 'glidingAverageRenderer'),
    ];

    return new Container(
      height: 300,
      child: TimeSeriesChart(
        data,
        animate: false,
        defaultRenderer: LineRendererConfig(
          includePoints: true,
          includeLine: false,
        ),
        customSeriesRenderers: [
          LineRendererConfig(
            customRendererId: 'glidingAverageRenderer',
            dashPattern: [1, 2],
          ),
        ],
        primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: 6,
          ),
        ),
        behaviors: [
          ChartTitle(
            'Power per Heart Rate (W / bpm)',
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
