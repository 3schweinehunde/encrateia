import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/enums.dart';

class AthleteScatterChart extends StatefulWidget {
  const AthleteScatterChart({
    Key? key,
    required this.athlete,
    required this.activities,
    required this.firstAttr,
    required this.secondAttr,
    required this.chartTitleText,
    required this.firstAxesText,
    required this.secondAxesText,
    this.flipVerticalAxis,
  }) : super(key: key);

  final Athlete? athlete;
  final List<Activity> activities;
  final ActivityAttr firstAttr;
  final ActivityAttr secondAttr;
  final String chartTitleText;
  final String firstAxesText;
  final String secondAxesText;
  final bool? flipVerticalAxis;

  @override
  AthleteScatterChartState createState() => AthleteScatterChartState();
}

class AthleteScatterChartState extends State<AthleteScatterChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Series<Activity, double>> data = <Series<Activity, double>>[
      Series<Activity, double>(
        id: '${widget.firstAttr} vs. ${widget.secondAttr}',
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
            behaviors: <ChartTitle<num>>[
              ChartTitle<num>(
                widget.firstAxesText,
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.bottom,
                titleOutsideJustification: OutsideJustification.end,
              ),
              ChartTitle<num>(
                widget.secondAxesText,
                titleStyleSpec: const TextStyleSpec(fontSize: 13),
                behaviorPosition: BehaviorPosition.start,
                titleOutsideJustification: OutsideJustification.end,
              ),
              ChartTitle<num>(
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

  int opacity({required Activity activity}) {
    return 255 -
        (DateTime.now().difference(activity.timeStamp!).inDays / 2).round();
  }
}
