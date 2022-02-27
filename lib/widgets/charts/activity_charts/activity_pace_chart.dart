import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/lap.dart';
import '/models/plot_point.dart';
import '/models/record_list.dart';
import '/utils/enums.dart';
import '/utils/graph_utils.dart';
import '/utils/my_line_chart.dart';

class ActivityPaceChart extends StatelessWidget {
  const ActivityPaceChart({Key? key,
    this.records,
    required this.activity,
    required this.athlete,
    required this.minimum,
    required this.maximum,
  }) : super(key: key);

  final RecordList<Event>? records;
  final Activity? activity;
  final Athlete? athlete;
  final double minimum;
  final double maximum;

  @override
  Widget build(BuildContext context) {
    final List<DoublePlotPoint> smoothedRecords = records!.toDoubleDataPoints(
      attribute: LapDoubleAttr.pace,
      amount: athlete!.recordAggregationCount,
    );

    final List<Series<DoublePlotPoint, int?>> data =
        <Series<DoublePlotPoint, int?>>[
      Series<DoublePlotPoint, int?>(
        id: 'Pace',
        colorFn: (_, __) => Color.black,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: smoothedRecords,
      )
    ];

    return FutureBuilder<List<Lap>>(
      future: activity!.laps,
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          final List<Lap> laps = snapshot.data!;
          return AspectRatio(
            aspectRatio:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1
                    : 2,
            child: MyLineChart(
              data: data,
              maxDomain: records!.last.distance!,
              laps: laps,
              domainTitle: 'Pace (min/km)',
              measureTickProviderSpec: const BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: false,
                  desiredTickCount: 5),
              domainTickProviderSpec:
                  const BasicNumericTickProviderSpec(desiredTickCount: 6),
              minimum: minimum,
              maximum: maximum,
              flipVerticalAxis: true,
            ),
          );
        } else {
          return GraphUtils.loadingContainer;
        }
      },
    );
  }
}
