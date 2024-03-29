import 'dart:math';
import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/activity_list.dart';
import '/models/athlete.dart';
import '/screens/show_activity_screen.dart';
import '/utils/enums.dart';
import '/utils/my_button.dart';
import 'pg_text.dart';

class AthleteTimeSeriesChart extends StatefulWidget {
  const AthleteTimeSeriesChart({
    Key? key,
    required this.athlete,
    required this.activities,
    required this.activityAttr,
    required this.chartTitleText,
    this.fullDecay,
    this.flipVerticalAxis,
  }) : super(key: key);

  final Athlete athlete;
  final List<Activity> activities;
  final ActivityAttr activityAttr;
  final String chartTitleText;
  final int? fullDecay;
  final bool? flipVerticalAxis;

  @override
  AthleteTimeSeriesChartState createState() => AthleteTimeSeriesChartState();
}

class AthleteTimeSeriesChartState extends State<AthleteTimeSeriesChart> {
  Activity? selectedActivity;
  late List<Activity> displayedActivities;
  int pagingOffset = 0;
  final int xAxesDays = 60;
  final int amountDisplayed = 40;
  late int numberOfActivities;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void _onSelectionChanged(SelectionModel<DateTime> model) {
    final List<SeriesDatum<dynamic>> selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      setState(() => selectedActivity = selectedDatum[1].datum as Activity?);
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
            activity.getAttribute(widget.activityAttr) as num?,
        data: displayedActivities,
      ),
      Series<Activity, DateTime>(
        id: 'gliding_${widget.activityAttr}',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (Activity activity, _) => activity.timeCreated,
        measureFn: (Activity activity, _) => activity.glidingMeasureAttribute,
        data: displayedActivities,
      )..setAttribute(rendererIdKey, 'glidingAverageRenderer'),
    ];

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 1
                  : 2,
          child: TimeSeriesChart(
            data,
            animate: true,
            flipVerticalAxis: widget.flipVerticalAxis ?? false,
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
            behaviors: <ChartTitle<DateTime>>[
              ChartTitle<DateTime>(
                widget.chartTitleText,
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.start,
                titleOutsideJustification: OutsideJustification.end,
              ),
              ChartTitle<DateTime>(
                'Date',
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.bottom,
                titleOutsideJustification: OutsideJustification.end,
              ),
              ChartTitle<DateTime>(
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
                onPressed:
                    (pagingOffset + amountDisplayed >= numberOfActivities)
                        ? null
                        : () {
                            pagingOffset =
                                pagingOffset + (amountDisplayed / 2).round();
                            setScope();
                          },
                child: const Text('<<'),
              ),
              const Spacer(),
              MyButton.save(
                onPressed: (pagingOffset == 0)
                    ? null
                    : () {
                        pagingOffset =
                            pagingOffset - (amountDisplayed / 2).round();
                        if (pagingOffset < 0) {
                          pagingOffset = 0;
                        }
                        setScope();
                      },
                child: const Text('>>'),
              ),
              const Spacer(),
            ],
          ),
        if (selectedActivity != null)
          SizedBox(
            height: 200,
            child: GridView.extent(
              padding: const EdgeInsets.all(5),
              maxCrossAxisExtent: 250,
              childAspectRatio: 5,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              children: <Widget>[
                MyButton.activity(
                  child: Text(selectedActivity!.name!),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) => ShowActivityScreen(
                        activity: selectedActivity!,
                        athlete: widget.athlete,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: PQText(
                    value: selectedActivity!.timeCreated,
                    pq: PQ.dateTime,
                    format: DateTimeFormat.longDateTime,
                  ),
                  subtitle: const Text('Time created'),
                ),
                ListTile(
                  title: PQText(
                    value: selectedActivity!.distance,
                    pq: PQ.distance,
                  ),
                  subtitle: const Text('Distance'),
                ),
                ListTile(
                  title: PQText(
                    value: selectedActivity!.avgSpeed,
                    pq: PQ.paceFromSpeed,
                  ),
                  subtitle: const Text('Average speed'),
                ),
                ListTile(
                  title:
                      PQText(value: selectedActivity!.avgPower, pq: PQ.power),
                  subtitle: const Text('Average power'),
                ),
                if (selectedActivity!.ftp != null)
                  ListTile(
                    title: PQText(value: selectedActivity!.ftp, pq: PQ.power),
                    subtitle: const Text('FTP'),
                  ),
                ListTile(
                    title: PQText(
                      value: selectedActivity!.avgHeartRate,
                      pq: PQ.heartRate,
                    ),
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
