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
    this.fullDecay,
  });

  final Athlete athlete;
  final List<Activity> activities;
  final ActivityAttr activityAttr;
  final String chartTitleText;
  final int fullDecay;

  @override
  _AthleteTimeSeriesChartState createState() => _AthleteTimeSeriesChartState();
}

class _AthleteTimeSeriesChartState extends State<AthleteTimeSeriesChart> {
  Activity selectedActivity;
  List<Activity> displayedActivities;
  int pagingOffset = 0;
  final int xAxesDays = 60;
  final int amountDisplayed = 40;
  int numberOfActivities;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void _onSelectionChanged(SelectionModel<DateTime> model) {
    final List<SeriesDatum<dynamic>> selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      setState(() => selectedActivity = selectedDatum[1].datum as Activity);
    }
  }

  @override
  void didUpdateWidget(AthleteTimeSeriesChart oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final List<Series<Activity, DateTime>> data = <Series<Activity, DateTime>>[
      Series<Activity, DateTime>(
        id: widget.activityAttr.toString(),
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Activity activity, _) => activity.timeCreated,
        measureFn: (Activity activity, _) =>
            activity.getAttribute(widget.activityAttr) as num,
        data: displayedActivities,
      ),
      Series<Activity, DateTime>(
        id: 'gliding_' + widget.activityAttr.toString(),
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Activity activity, _) => activity.timeCreated,
        measureFn: (Activity activity, _) => activity.glidingMeasureAttribute,
        data: displayedActivities,
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
              ChartTitle(
                '${widget.chartTitleText} Diagram created with Encrateia https://encreteia.informatom.com',
                behaviorPosition: BehaviorPosition.top,
                titleOutsideJustification: OutsideJustification.endDrawArea,
                titleStyleSpec: const TextStyleSpec(fontSize: 10),
              )
            ],
          ),
        ),
        if (amountDisplayed < numberOfActivities)
          Row(
            children: <Widget>[
              const Spacer(),
              MyButton.save(
                child: const Text('<<'),
                onPressed:
                    (pagingOffset + amountDisplayed >= numberOfActivities)
                        ? null
                        : () {
                            pagingOffset =
                                pagingOffset + (amountDisplayed / 2).round();
                            setScope();
                          },
              ),
              const Spacer(),
              MyButton.save(
                child: const Text('>>'),
                onPressed: (pagingOffset == 0)
                    ? null
                    : () {
                        pagingOffset =
                            pagingOffset - (amountDisplayed / 2).round();
                        if (pagingOffset < 0)
                          pagingOffset = 0;
                        setScope();
                      },
              ),
              const Spacer(),
            ],
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
                  child: Text(selectedActivity.name),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) => ShowActivityScreen(
                        activity: selectedActivity,
                        athlete: widget.athlete,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(DateFormat('dd MMM yyyy, h:mm:ss')
                      .format(selectedActivity.timeCreated)),
                  subtitle: const Text('Time created'),
                ),
                ListTile(
                  title: Text(selectedActivity.distance.toString() + ' m'),
                  subtitle: const Text('Distance'),
                ),
                ListTile(
                  title: Text(selectedActivity.avgSpeed.toPace() + ' min/km'),
                  subtitle: const Text('Average speed'),
                ),
                ListTile(
                  title:
                      Text(selectedActivity.avgPower.toStringAsFixed(1) + ' W'),
                  subtitle: const Text('Average power'),
                ),
                if (selectedActivity.ftp != null)
                  ListTile(
                    title: Text(selectedActivity.ftp.toStringAsFixed(1) + ' W'),
                    subtitle: const Text('FTP'),
                  ),
                ListTile(
                    title:
                        Text(selectedActivity.avgHeartRate.toString() + ' bpm'),
                    subtitle: const Text('Average heart rate')),
              ],
            ),
          ),
      ],
    );
  }

  void setScope() {
    displayedActivities = widget.activities.sublist(
        min(pagingOffset, max(numberOfActivities - amountDisplayed, 0)),
        min(pagingOffset + amountDisplayed, numberOfActivities));
    setState(() {});
  }

  void getData() {
    numberOfActivities = widget.activities.length;
    ActivityList<Activity>(widget.activities).enrichGlidingAverage(
      activityAttr: widget.activityAttr,
      fullDecay: widget.fullDecay ?? 30,
    );
    setScope();
  }
}
