import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/my_line_chart.dart';
import 'package:flutter/material.dart';

class ActivityPowerChart extends StatelessWidget {
  const ActivityPowerChart({
    this.records,
    @required this.activity,
    @required this.athlete,
    this.powerZones,
  });

  final RecordList<Event> records;
  final Activity activity;
  final Athlete athlete;
  final List<PowerZone> powerZones;

  @override
  Widget build(BuildContext context) {
    final List<IntPlotPoint> smoothedRecords = records.toIntDataPoints(
      attribute: LapIntAttr.power,
      amount: athlete.recordAggregationCount,
    );

    final List<Series<IntPlotPoint, int>> data = <Series<IntPlotPoint, int>>[
      Series<IntPlotPoint, int>(
        id: 'Power',
        colorFn: (_, __) => Color.black,
        domainFn: (IntPlotPoint record, _) => record.domain,
        measureFn: (IntPlotPoint record, _) => record.measure,
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
              powerZones: powerZones,
              domainTitle: 'Power (W)',
              measureTickProviderSpec: const BasicNumericTickProviderSpec(
                  zeroBound: false, desiredTickCount: 6),
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
