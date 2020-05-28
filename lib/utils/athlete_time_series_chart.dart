import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/activity_list.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/show_activity_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/utils/date_time_utils.dart';

class AthleteTimeSeriesChart extends StatefulWidget {
  const AthleteTimeSeriesChart({
    @required this.athlete,
    @required this.activities,
    @required this.activityAttr,
    @required this.chartTitleText,
  });

  final Athlete athlete;
  final List<Activity> activities;
  final ActivityAttr activityAttr;
  final String chartTitleText;

  @override
  _AthleteTimeSeriesChartState createState() => _AthleteTimeSeriesChartState();
}

class _AthleteTimeSeriesChartState extends State<AthleteTimeSeriesChart> {
  Activity selectedActivity;

  void _onSelectionChanged(SelectionModel<DateTime> model) {
    final List<SeriesDatum<dynamic>> selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      setState(() => selectedActivity = selectedDatum[1].datum as Activity);
    }
  }

  @override
  Widget build(BuildContext context) {
    const int xAxesDays = 60;

    ActivityList<Activity>(widget.activities).enrichGlidingAverage(
      activityAttr: widget.activityAttr,
      fullDecay: 30,
    );

    List<Activity> recentActivities = widget.activities
        .where((Activity activity) =>
            DateTime.now().difference(activity.db.timeCreated).inDays <
            xAxesDays)
        .toList();
    if (recentActivities.length < 40) {
      final int amount = min(widget.activities.length, 40);
      recentActivities = widget.activities.sublist(0, amount);
    }

    final List<Series<Activity, DateTime>> data = <Series<Activity, DateTime>>[
      Series<Activity, DateTime>(
        id: widget.activityAttr.toString(),
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) =>
            activity.getAttribute(widget.activityAttr) as num,
        data: recentActivities,
      ),
      Series<Activity, DateTime>(
        id: 'gliding_' + widget.activityAttr.toString(),
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Activity activity, _) => activity.db.timeCreated,
        measureFn: (Activity activity, _) => activity.glidingMeasureAttribute,
        data: recentActivities,
      )..setAttribute(rendererIdKey, 'glidingAverageRenderer'),
    ];

    return Column(
      children: <Widget>[
        Container(
          height: 300,
          child: TimeSeriesChart(
            data,
            animate: true,
            selectionModels: <SelectionModelConfig<DateTime>>[
              SelectionModelConfig<DateTime>(
                type: SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
            defaultRenderer: LineRendererConfig<DateTime>(
              includePoints: true,
              includeLine: false,
            ),
            customSeriesRenderers: <LineRendererConfig<DateTime>>[
              LineRendererConfig<DateTime>(
                customRendererId: 'glidingAverageRenderer',
                dashPattern: <int>[1, 2],
              ),
            ],
            primaryMeasureAxis: const NumericAxisSpec(
              tickProviderSpec: BasicNumericTickProviderSpec(
                zeroBound: false,
                dataIsInWholeNumbers: false,
                desiredTickCount: 6,
              ),
            ),
            behaviors: <ChartTitle>[
              ChartTitle(
                widget.chartTitleText,
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.start,
                titleOutsideJustification: OutsideJustification.end,
              ),
              ChartTitle(
                'Date',
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.bottom,
                titleOutsideJustification: OutsideJustification.end,
              ),
            ],
          ),
        ),
        if (selectedActivity != null)
          Container(
            height: 200,
            child: GridView.count(
              padding: const EdgeInsets.all(5),
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 4
                      : 2,
              childAspectRatio: 4,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              children: <Widget>[
                MyButton.activity(
                  child: Text(selectedActivity.db.name),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ShowActivityScreen(
                        activity: selectedActivity,
                        athlete: widget.athlete,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(DateFormat('dd MMM yyyy, h:mm:ss')
                      .format(selectedActivity.db.timeCreated)),
                  subtitle: const Text('Time created'),
                ),
                ListTile(
                    title: Text(selectedActivity.db.distance.toString() + ' m'),
                    subtitle: const Text('Distance')),
                ListTile(
                    title:
                        Text(selectedActivity.db.avgSpeed.toPace() + ' min/km'),
                    subtitle: const Text('Average speed')),
                ListTile(
                    title: Text(
                        selectedActivity.db.avgPower.toStringAsFixed(1) + ' W'),
                    subtitle: const Text('Average power')),
                ListTile(
                    title: Text(
                        selectedActivity.db.avgHeartRate.toString() + ' bpm'),
                    subtitle: const Text('Average heart rate')),
              ],
            ),
          ),
      ],
    );
  }
}
