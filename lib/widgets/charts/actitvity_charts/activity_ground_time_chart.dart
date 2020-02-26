import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:encrateia/utils/enums.dart';

class ActivityGroundTimeChart extends StatelessWidget {
  final List<Event> records;
  final Activity activity;

  ActivityGroundTimeChart({this.records, @required this.activity});

  @override
  Widget build(BuildContext context) {
    var nonZero = records.where((value) => value.db.groundTime > 0);
    var smoothedRecords = Event.toDoubleDataPoints(
      attribute: LapDoubleAttr.groundTime,
      records: nonZero,
      amount: 30,
    );

    List<Series<dynamic, num>> data = [
      Series<DoublePlotPoint, int>(
        id: 'Ground Time',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: smoothedRecords,
      )
    ];

    return FutureBuilder<List<Lap>>(
      future: activity.laps,
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          var laps = snapshot.data;
          return Container(
            height: 300,
            child: MyLineChart(
              data: data,
              maxDomain: nonZero.last.db.distance,
              laps: laps,
              domainTitle: 'Ground Time (ms)',
              measureTickProviderSpec: BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: false,
                  desiredTickCount: 5),
              domainTickProviderSpec:
              BasicNumericTickProviderSpec(desiredTickCount: 6),
            ),
          );
        } else return GraphUtils.loadingContainer;
      },
    );
  }
}
