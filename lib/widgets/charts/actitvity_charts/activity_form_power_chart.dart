import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:encrateia/utils/enums.dart';

class ActivityFormPowerChart extends StatelessWidget {
  final List<Event> records;
  final Activity activity;

  ActivityFormPowerChart({this.records, @required this.activity});

  @override
  Widget build(BuildContext context) {

    var smoothedRecords = Event.toIntDataPoints(
      attribute: LapIntAttr.formPower,
      records: records,
      amount: 15,
    );

    List<Series<dynamic, num>> data = [
       Series<IntPlotPoint, int>(
        id: 'Form power',
        colorFn: (_, __) => MaterialPalette.green.shadeDefault,
        domainFn: (IntPlotPoint record, _) => record.domain,
        measureFn: (IntPlotPoint record, _) => record.measure,
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
              maxDomain: records.last.db.distance,
              laps: laps,
              domainTitle: 'Form Power (W)',
                            measureTickProviderSpec: BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: true,
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
