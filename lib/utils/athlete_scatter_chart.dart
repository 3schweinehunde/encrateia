import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/enums.dart';

class AthleteScatterChart extends StatefulWidget {
  const AthleteScatterChart({
    @required this.athlete,
    @required this.activities,
    @required this.firstAttr,
    @required this.secondAttr,
    @required this.chartTitleText,
    @required this.firstAxesText,
    @required this.secondAxesText,
    this.flipVerticalAxis,
  });

  final Athlete athlete;
  final List<Activity> activities;
  final ActivityAttr firstAttr;
  final ActivityAttr secondAttr;
  final String chartTitleText;
  final String firstAxesText;
  final String secondAxesText;
  final bool flipVerticalAxis;

  @override
  _AthleteScatterChartState createState() => _AthleteScatterChartState();
}

class _AthleteScatterChartState extends State<AthleteScatterChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Series<Activity, double>> data = <Series<Activity, double>>[
      Series<Activity, double>(
        id: widget.firstAttr.toString() +
            ' vs. ' +
            widget.secondAttr.toString(),
        colorFn: (Activity activity, __) => Color(
            r: activity == widget.activities.first ? 255 : 0,
            g: 0,
            b: 0,
            a: opacity(activity: activity)),
        domainFn: (Activity activity, _) =>
            activity.getAttribute(widget.firstAttr) as double,
        measureFn: (Activity activity, _) =>
            activity.getAttribute(widget.secondAttr) as double,
        data: widget.activities.reversed.toList(),
        radiusPxFn: (Activity activity, _) =>
            activity == widget.activities.first ? 5 : 3,
      ),
    ];

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 1
                  : 2,
          child: ScatterPlotChart(
            data,
            animate: false,
            primaryMeasureAxis: const NumericAxisSpec(
              tickProviderSpec: BasicNumericTickProviderSpec(
                zeroBound: false,
                dataIsInWholeNumbers: false,
                desiredTickCount: 6,
              ),
            ),
            flipVerticalAxis: widget.flipVerticalAxis ?? false,
            behaviors: <ChartTitle>[
              ChartTitle(
                widget.firstAxesText,
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.bottom,
                titleOutsideJustification: OutsideJustification.end,
              ),
              ChartTitle(
                widget.secondAxesText,
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.start,
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
        const Text('last Activity in red, activities fade out with time')
      ],
    );
  }

  int opacity({Activity activity}) {
    return 255 -
        (DateTime.now().difference(activity.timeStamp).inDays / 2).round();
  }
}
