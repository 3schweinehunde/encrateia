import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:encrateia/utils/enums.dart';

class ActivityHeartRateChart extends StatelessWidget {
  final List<Event> records;
  final Activity activity;

  ActivityHeartRateChart({this.records, @required this.activity});

  @override
  Widget build(BuildContext context) {
    var nonZero = records.where(
        (value) => value.db.heartRate != null && value.db.heartRate > 10);
    var smoothedRecords = Event.toIntDataPoints(
      attribute: LapIntAttr.heartRate,
      records: nonZero,
      amount: 30,
    );

    List<Series<dynamic, num>> data = [
       Series<IntPlotPoint, int>(
        id: 'Heart Rate',
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        domainFn: (IntPlotPoint point, _) => point.domain,
        measureFn: (IntPlotPoint point, _) => point.measure,
        data: smoothedRecords,
      )
    ];

    return FutureBuilder<List<Lap>>(
      future: Lap.by(activity: activity),
      builder: (BuildContext context, AsyncSnapshot<List<Lap>> snapshot) {
        if (snapshot.hasData) {
          var laps = snapshot.data;
          return Container(
            height: 300,
            child: MyLineChart(
              data: data,
              maxDomain: nonZero.last.db.distance,
              laps: laps,
              domainTitle: 'Heart Rate (bpm)',
              measureTickProviderSpec: BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: true,
                  desiredTickCount: 6),
              domainTickProviderSpec:
                  BasicNumericTickProviderSpec(desiredTickCount: 6),
            ),
          );
        } else return GraphUtils.loadingContainer;
      },
    );
  }
}
