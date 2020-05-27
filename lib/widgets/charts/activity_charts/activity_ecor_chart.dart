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
      amount: athlete.db.recordAggregationCount,
      weight: weight,
    );

    final List<Series<dynamic, num>> data = <Series<dynamic, num>>[
      Series<DoublePlotPoint, int>(
        id: 'Ecor',
        colorFn: (_, __) => MaterialPalette.gray.shade700,
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

          return Container(
            height: 300,
            child: MyLineChart(
              data: data,
              maxDomain: records.last.db.distance,
              laps: laps,
              domainTitle: 'Ecor (W s/kg m)',
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
