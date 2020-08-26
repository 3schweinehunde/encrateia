import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:encrateia/utils/enums.dart';

class ActivityEcorChart extends StatelessWidget {
  const ActivityEcorChart({
    this.records,
    @required this.activity,
    @required this.weight,
    @required this.athlete,
  });

  final RecordList<Event> records;
  final Activity activity;
  final Athlete athlete;
  final double weight;

  @override
  Widget build(BuildContext context) {
    final List<DoublePlotPoint> smoothedRecords = records.toDoubleDataPoints(
      attribute: LapDoubleAttr.ecor,
      amount: athlete.recordAggregationCount,
      weight: weight,
    );

    final List<Series<DoublePlotPoint, int>> data =
        <Series<DoublePlotPoint, int>>[
      Series<DoublePlotPoint, int>(
        id: 'Ecor',
        colorFn: (_, __) => Color.black,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: smoothedRecords,
      )
    ];

    return FutureBuilder<List<Lap>>(
      future: activity.laps,
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          final List<Lap> laps = snapshot.data;

          return AspectRatio(
            aspectRatio:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 1
                    : 2,
            child: MyLineChart(
              data: data,
              maxDomain: records.last.distance,
              laps: laps,
              domainTitle: 'Ecor (kJ/kg/km)',
              measureTickProviderSpec: const BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: false,
                  desiredTickCount: 6),
              domainTickProviderSpec:
                  const BasicNumericTickProviderSpec(desiredTickCount: 6),
            ),
          );
        } else
          return GraphUtils.loadingContainer;
      },
    );
  }
}
