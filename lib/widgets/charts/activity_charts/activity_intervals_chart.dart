import 'package:charts_flutter/flutter.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/plot_point.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/utils/graph_utils.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:charts_common/common.dart' as common show ChartBehavior;

class ActivityIntervalsChart extends StatefulWidget {
  const ActivityIntervalsChart({
    this.records,
    @required this.activity,
    @required this.athlete,
    @required this.minimum,
    @required this.maximum,
  });

  final RecordList<Event> records;
  final Activity activity;
  final Athlete athlete;
  final double minimum;
  final double maximum;

  @override
  _ActivityIntervalsChartState createState() => _ActivityIntervalsChartState();
}

class _ActivityIntervalsChartState extends State<ActivityIntervalsChart> {
  DoublePlotPoint selectedPlotPoint;
  Event selectedRecord;
  List<Lap> laps = <Lap>[];
  encrateia.Interval interval = encrateia.Interval();

  @override
  void initState() {
    getData();
    super.initState();
  }

  void _onSelectionChanged(SelectionModel<num> model) {
    final List<SeriesDatum<dynamic>> selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      selectedPlotPoint = selectedDatum[0].datum as DoublePlotPoint;
      selectedRecord = widget.records.firstWhere((Event record) =>
          record.distance.round() == selectedPlotPoint.domain);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DoublePlotPoint> smoothedRecords =
        widget.records.toDoubleDataPoints(
      attribute: LapDoubleAttr.speed,
      amount: widget.athlete.recordAggregationCount,
    );

    final List<Series<DoublePlotPoint, int>> data =
        <Series<DoublePlotPoint, int>>[
      Series<DoublePlotPoint, int>(
        id: 'Speed',
        colorFn: (_, __) => Color.black,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: smoothedRecords,
      )
    ];

    if (laps.isNotEmpty)
      return Column(
        children: <Widget>[
          Container(
            height: 300,
            child: LineChart(
              data,
              defaultRenderer: LineRendererConfig<num>(
                includeArea: true,
              ),
              domainAxis: NumericAxisSpec(
                viewport: NumericExtents(0, widget.records.last.distance + 500),
                tickProviderSpec:
                    const BasicNumericTickProviderSpec(desiredTickCount: 6),
              ),
              primaryMeasureAxis: NumericAxisSpec(
                  tickProviderSpec: const BasicNumericTickProviderSpec(
                      zeroBound: false,
                      dataIsInWholeNumbers: false,
                      desiredTickCount: 5),
                  viewport: NumericExtents(widget.minimum, widget.maximum)),
              animate: false,
              selectionModels: <SelectionModelConfig<num>>[
                SelectionModelConfig<num>(
                  type: SelectionModelType.info,
                  changedListener: _onSelectionChanged,
                )
              ],
              layoutConfig: GraphUtils.layoutConfig,
              behaviors: <ChartBehavior<common.ChartBehavior<dynamic>>>[
                    PanAndZoomBehavior(),
                    RangeAnnotation(GraphUtils.rangeAnnotations(laps: laps)),
                  ] +
                  GraphUtils.axis(measureTitle: 'Speed (km/h)'),
            ),
          ),
          if (selectedRecord != null)
            Column(
              children: <Widget>[
                Text('Current selection: ' +
                    selectedRecord.distance.round().toString() +
                    ' m; ' +
                    (selectedRecord.speed * 3.6).toStringAsPrecision(2) +
                    ' km/h; ' +
                    (selectedRecord.power ?? 0).toString() +
                    ' W'),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    MyButton.activity(
                        child: const Text('Select as start'),
                        onPressed: () {
                          interval.firstRecordId = selectedRecord.id;
                          setState(() {});
                        }),
                    const Spacer(),
                    if (interval.firstRecordId == 0)
                      const Text('No start record selected'),
                    if (interval.firstRecordId > 0)
                      Text('Selected: ' +
                          interval.firstRecordId.round().toString() +
                          ' (id)'),
                    const Spacer(),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    MyButton.activity(
                      child: const Text('Select as end'),
                      onPressed: () {
                        interval.lastRecordId = selectedRecord.id;
                        setState(() {});
                      },
                    ),
                    const Spacer(),
                    if (interval.lastRecordId == 0)
                      const Text('No end record selected'),
                    if (interval.lastRecordId > 0)
                      Text('Selected: ' +
                          interval.lastRecordId.round().toString() +
                          ' (id)'),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          if (selectedRecord == null)
            Container(
              child: const Text('Select a record to continue.'),
            ),
        ],
      );
    else
      return GraphUtils.loadingContainer;
  }

  Future<void> getData() async {
    laps = await widget.activity.laps;
    setState(() {});
  }
}
