import 'dart:math';
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
import 'package:flutter/rendering.dart';

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
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: LineChart(
                data,
                defaultRenderer: LineRendererConfig<num>(
                  includeArea: true,
                ),
                domainAxis: NumericAxisSpec(
                  viewport:
                      NumericExtents(0, widget.records.last.distance + 500),
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
                      if (interval.firstDistance > 0 &&
                          interval.lastDistance > 0)
                        RangeAnnotation(
                          <RangeAnnotationSegment<int>>[
                            RangeAnnotationSegment<int>(
                              interval.firstDistance.round(),
                              interval.lastDistance.round(),
                              RangeAnnotationAxisType.domain,
                              color: const Color(r: 255, g: 200, b: 200),
                              endLabel: 'Interval',
                            )
                          ],
                        ),
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
                            interval.firstDistance = selectedRecord.distance;
                            setState(() {});
                          }),
                      const Spacer(),
                      if (interval.firstRecordId == 0)
                        const Text('No start record selected'),
                      if (interval.firstRecordId > 0)
                        Text('Selected: ' +
                            interval.firstDistance.round().toString() +
                            ' m'),
                      const Spacer(),
                    ],
                  ),
                  ButtonTheme(
                    minWidth: 36,
                    child: Row(children: <Widget>[
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('-100'),
                        onPressed: () => moveInterval(
                          amount: -100,
                          boundary: IntervalBoundary.left,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('-10'),
                        onPressed: () => moveInterval(
                          amount: -10,
                          boundary: IntervalBoundary.left,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('-1'),
                        onPressed: () => moveInterval(
                          amount: -1,
                          boundary: IntervalBoundary.left,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('+1'),
                        onPressed: () => moveInterval(
                          amount: 1,
                          boundary: IntervalBoundary.left,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('+10'),
                        onPressed: () => moveInterval(
                          amount: 10,
                          boundary: IntervalBoundary.left,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('+100'),
                        onPressed: () => moveInterval(
                          amount: 100,
                          boundary: IntervalBoundary.left,
                        ),
                      ),
                      const Spacer(),
                    ]),
                  ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('Select as end'),
                        onPressed: () {
                          interval.lastRecordId = selectedRecord.id;
                          interval.lastDistance = selectedRecord.distance;
                          setState(() {});
                        },
                      ),
                      const Spacer(),
                      if (interval.lastRecordId == 0)
                        const Text('No end record selected'),
                      if (interval.lastRecordId > 0)
                        Text('Selected: ' +
                            interval.lastDistance.round().toString() +
                            ' m'),
                      const Spacer(),
                    ],
                  ),
                  ButtonTheme(
                    minWidth: 36,
                    child: Row(children: <Widget>[
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('-100'),
                        onPressed: () => moveInterval(
                          amount: -100,
                          boundary: IntervalBoundary.right,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('-10'),
                        onPressed: () => moveInterval(
                          amount: -10,
                          boundary: IntervalBoundary.right,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('-1'),
                        onPressed: () => moveInterval(
                          amount: -1,
                          boundary: IntervalBoundary.right,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('+1'),
                        onPressed: () => moveInterval(
                          amount: 1,
                          boundary: IntervalBoundary.right,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('+10'),
                        onPressed: () => moveInterval(
                          amount: 10,
                          boundary: IntervalBoundary.right,
                        ),
                      ),
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('+100'),
                        onPressed: () => moveInterval(
                          amount: 100,
                          boundary: IntervalBoundary.right,
                        ),
                      ),
                      const Spacer(),
                    ]),
                  ),
                ],
              ),
            if (interval.firstDistance > 0 && interval.lastDistance > 0)
              Row(
                children: <Widget>[
                  const Spacer(),
                  MyButton.save(
                    child: const Text('Save interval'),
                    onPressed: () async {
                      await interval.calculateAndSave(
                          records: RecordList<Event>(widget.records
                              .where((Event record) =>
                                  record.id <= interval.firstRecordId &&
                                  record.id <= interval.lastRecordId)
                              .toList()));
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            if (selectedRecord == null)
              Container(
                child: const Text('Select a record to continue.'),
              ),
          ],
        ),
      );
    else
      return GraphUtils.loadingContainer;
  }

  Future<void> getData() async {
    laps = await widget.activity.laps;
    interval.athletesId = widget.athlete.id;
    interval.activitiesId = widget.activity.id;
    setState(() {});
  }

  void moveInterval({int amount, IntervalBoundary boundary}) {
    if (amount < 0) {
      switch (boundary) {
        case IntervalBoundary.left:
          {
            interval.firstRecordId =
                max(interval.firstRecordId + amount, widget.records.first.id);
            selectedRecord = widget.records.firstWhere(
                (Event record) => record.id == interval.firstRecordId);
            interval.firstDistance = selectedRecord.distance;
            break;
          }
        case IntervalBoundary.right:
          {
            interval.lastRecordId =
                max(interval.lastRecordId + amount, interval.firstRecordId + 1);
            selectedRecord = widget.records.firstWhere(
                (Event record) => record.id == interval.lastRecordId);
            interval.lastDistance = selectedRecord.distance;
          }
      }
    } else {
      switch (boundary) {
        case IntervalBoundary.left:
          {
            interval.firstRecordId =
                min(interval.firstRecordId + amount, interval.lastRecordId - 1);
            selectedRecord = widget.records.firstWhere(
                (Event record) => record.id == interval.firstRecordId);
            interval.firstDistance = selectedRecord.distance;
            break;
          }
        case IntervalBoundary.right:
          {
            interval.lastRecordId =
                min(interval.lastRecordId + amount, widget.records.last.id);
            selectedRecord = widget.records.firstWhere(
                (Event record) => record.id == interval.lastRecordId);
            interval.lastDistance = selectedRecord.distance;
          }
      }
    }
    setState(() {});
  }
}
