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

class ActivityGroundTimeChart extends StatelessWidget {
  const ActivityGroundTimeChart({
    this.records,
    @required this.activity,
    @required this.athlete,
  });

  final RecordList<Event> records;
  final Activity activity;
  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    final List<DoublePlotPoint> smoothedRecords = records.toDoubleDataPoints(
      attribute: LapDoubleAttr.groundTime,
      amount: athlete.recordAggregationCount,
    );

    final List<Series<DoublePlotPoint, int>> data = <Series<DoublePlotPoint, int>>[
      Series<DoublePlotPoint, int>(
        id: 'Ground Time',
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
          return Container(
            height: 300,
            child: MyLineChart(
              data: data,
              maxDomain: records.last.distance,
              laps: laps,
              domainTitle: 'Ground Time (ms)',
              measureTickProviderSpec: const BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: false,
                  desiredTickCount: 5),
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
