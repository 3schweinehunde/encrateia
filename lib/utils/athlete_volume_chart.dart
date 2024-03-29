import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;
import '/models/activity.dart';
import '/models/athlete.dart';
import '/utils/enums.dart';

class AthleteVolumeChart extends StatefulWidget {
  const AthleteVolumeChart({
    Key? key,
    required this.athlete,
    required this.activities,
    required this.volumeAttr,
    required this.chartTitleText,
  }) : super(key: key);

  final Athlete? athlete;
  final List<Activity> activities;
  final ActivityAttr volumeAttr;
  final String chartTitleText;

  @override
  AthleteVolumeChartState createState() => AthleteVolumeChartState();
}

class AthleteVolumeChartState extends State<AthleteVolumeChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Series<Activity, DateTime>> data = <Series<Activity, DateTime>>[
      Series<Activity, DateTime>(
        id: widget.volumeAttr.toString(),
        colorFn: (Activity activity, __) => colorForYear(activity: activity)!,
        domainFn: (Activity activity, _) =>
            movedIntoThisYear(activity: activity),
        measureFn: (Activity activity, _) =>
            activity.getAttribute(widget.volumeAttr) as num?,
        data: widget.activities,
      ),
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
            animate: false,
            defaultRenderer: LineRendererConfig<DateTime>(
              includePoints: true,
              includeLine: false,
            ),
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
        Wrap(children: <Widget>[
          const Text('Legend:'),
          for (Color? color in colorPalette) legendTextWidget(color: color)
        ])
      ],
    );
  }

  DateTime movedIntoThisYear({required Activity activity}) => DateTime(
      DateTime.now().year,
      activity.timeStamp!.month,
      activity.timeStamp!.day,
      activity.timeStamp!.hour,
      activity.timeStamp!.minute,
      activity.timeStamp!.second);

  Color? colorForYear({required Activity activity}) {
    final int yearsAgo = DateTime.now().year - activity.timeStamp!.year;
    return colorPalette[yearsAgo % colorPalette.length];
  }

  final List<Color?> colorPalette = <Color?>[
    MaterialPalette.blue.shadeDefault,
    MaterialPalette.red.shadeDefault,
    MaterialPalette.green.shadeDefault,
    MaterialPalette.cyan.shadeDefault,
    MaterialPalette.deepOrange.shadeDefault,
    MaterialPalette.indigo.shadeDefault,
    MaterialPalette.pink.shadeDefault,
    MaterialPalette.lime.shadeDefault,
    MaterialPalette.purple.shadeDefault,
    MaterialPalette.teal.shadeDefault,
    MaterialPalette.gray.shadeDefault,
  ];

  Widget legendTextWidget({Color? color}) {
    final int yearsAgo = colorPalette.indexOf(color);
    final painting.Color materialColor = painting.Color.fromRGBO(
        colorPalette[yearsAgo % colorPalette.length]!.r,
        colorPalette[yearsAgo % colorPalette.length]!.g,
        colorPalette[yearsAgo % colorPalette.length]!.b,
        1.0);
    final int year = DateTime.now().year - yearsAgo;
    return Text('  $year  ', style: painting.TextStyle(color: materialColor));
  }
}
