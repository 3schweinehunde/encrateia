import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/activity_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/enums.dart';

class AthletePowerChart extends StatelessWidget {
  final List<Activity> activities;

  AthletePowerChart({@required this.activities});

  @override
  Widget build(BuildContext context) {
    int xAxesDays = 60;

    ActivityList(activities: activities).enrichGlidingAverage(
      quantity: ActivityAttr.avgPower,
      fullDecay: 30,
    );

    var recentActivities = activities
        .where((activity) =>
            DateTime.now().difference(activity.db.timeCreated).inDays <
            xAxesDays)
        .toList();

    var data = [
      Series<Activity, DateTime>(
        id: 'average power',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) => activity.db.avgPower,
        data: recentActivities,
      ),
      Series<Activity, DateTime>(
        id: 'Gliding average power',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) => activity.glidingAvgPower,
        data: recentActivities,
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
            'Power (W)',
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
