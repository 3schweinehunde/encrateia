import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/activity_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/enums.dart';

class AthleteEcorChart extends StatelessWidget {
  final List<Activity> activities;

  AthleteEcorChart({@required this.activities});

  @override
  Widget build(BuildContext context) {
    int xAxesDays = 60;

    ActivityList(activities: activities).enrichGlidingAverage(
      quantity: ActivityAttr.ecor,
      fullDecay: 30,
    );

    var recentActivities = activities
        .where((activity) =>
            DateTime.now().difference(activity.db.timeCreated).inDays <
            xAxesDays)
        .toList();

    var data = [
      Series<Activity, DateTime>(
        id: 'ecor',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) =>
            activity.db.avgPower / activity.db.avgSpeed / activity.weight,
        data: recentActivities,
      ),
      Series<Activity, DateTime>(
        id: 'gliding_ecor',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) => activity.glidingEcor,
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
            'Ecor (W s/kg m)',
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
