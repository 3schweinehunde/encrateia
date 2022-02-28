import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/interval.dart' as encrateia;
import '/models/lap.dart';
import '/models/plot_point.dart';
import '/models/record_list.dart';
import '/utils/enums.dart';
import '/utils/graph_utils.dart';
import '/utils/my_button.dart';

class ActivityIntervalsChart extends StatefulWidget {
  const ActivityIntervalsChart({
    Key? key,
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
  _ActivityIntervalsChartState createState() => _ActivityIntervalsChartState();
}

class _ActivityIntervalsChartState extends State<ActivityIntervalsChart> {
  DoublePlotPoint? selectedPlotPoint;
  Event? selectedRecord;
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
      selectedPlotPoint = selectedDatum[0].datum as DoublePlotPoint?;
      selectedRecord = widget.records!.firstWhere((Event record) =>
          record.distance!.round() == selectedPlotPoint!.domain);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DoublePlotPoint> smoothedRecords =
        widget.records!.toDoubleDataPoints(
      attribute: LapDoubleAttr.speed,
      amount: widget.athlete!.recordAggregationCount,
    );

    final List<Series<DoublePlotPoint, int?>> data =
        <Series<DoublePlotPoint, int?>>[
      Series<DoublePlotPoint, int?>(
        id: 'Speed',
        colorFn: (_, __) => Color.black,
        domainFn: (DoublePlotPoint record, _) => record.domain,
        measureFn: (DoublePlotPoint record, _) => record.measure,
        data: smoothedRecords,
      )
    ];

    if (laps.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 1
                      : 2.5,
              child: LineChart(
                data as List<Series<dynamic, num>>,
                defaultRenderer: LineRendererConfig<num>(
                  includeArea: true,
                ),
                domainAxis: NumericAxisSpec(
                  viewport:
                      NumericExtents(0, widget.records!.last.distance! + 500),
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
                behaviors: <ChartBehavior<num>>[
                      PanAndZoomBehavior<num>(),
                      RangeAnnotation<num>(
                          GraphUtils.rangeAnnotations(laps: laps)),
                      RangeAnnotation<num>(
                        <RangeAnnotationSegment<int>>[
                          if (interval.firstDistance! > 0 &&
                              interval.lastDistance! > 0)
                            RangeAnnotationSegment<int>(
                              interval.firstDistance!.round(),
                              interval.lastDistance!.round(),
                              RangeAnnotationAxisType.domain,
                              color: const Color(r: 255, g: 200, b: 200),
                              endLabel: 'Interval',
                            ),
                          if (selectedRecord != null)
                            RangeAnnotationSegment<int>(
                              (selectedRecord!.distance! - 10).round(),
                              (selectedRecord!.distance! + 10).round(),
                              RangeAnnotationAxisType.domain,
                              color: const Color(r: 200, g: 255, b: 200),
                              endLabel: '',
                            ),
                          if (selectedRecord != null)
                            RangeAnnotationSegment<int>(
                              (selectedRecord!.distance! - 1).round(),
                              (selectedRecord!.distance! + 1).round(),
                              RangeAnnotationAxisType.domain,
                              color: const Color(r: 0, g: 100, b: 0),
                              endLabel: 'Cursor',
                            ),
                        ],
                      ),
                    ] +
                    GraphUtils.axis(measureTitle: 'Speed (km/h)'),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedRecord != null)
              Column(
                children: <Widget>[
                  Wrap(children: <Widget>[
                    const SizedBox(width: 20),
                    Text('Cursor position: ' +
                        selectedRecord!.distance!.round().toString() +
                        ' m; ' +
                        (selectedRecord!.speed! * 3.6).toStringAsPrecision(2) +
                        ' km/h; ' +
                        (selectedRecord!.power ?? 0).toString() +
                        ' W. \n' +
                        'Use Buttons to move Cursor'),
                    const Spacer(),
                  ]),
                  if (selectedRecord != null)
                    ButtonTheme(
                      minWidth: 36,
                      child: Row(children: <Widget>[
                        const Spacer(),
                        MyButton.activity(
                          child: const Text('-100'),
                          onPressed: () => moveSelectedRecord(amount: -100),
                        ),
                        const Spacer(),
                        MyButton.activity(
                          child: const Text('-10'),
                          onPressed: () => moveSelectedRecord(amount: -10),
                        ),
                        const Spacer(),
                        MyButton.activity(
                          child: const Text('-1'),
                          onPressed: () => moveSelectedRecord(amount: -1),
                        ),
                        const Spacer(),
                        MyButton.activity(
                          child: const Text('+1'),
                          onPressed: () => moveSelectedRecord(amount: 1),
                        ),
                        const Spacer(),
                        MyButton.activity(
                          child: const Text('+10'),
                          onPressed: () => moveSelectedRecord(amount: 10),
                        ),
                        const Spacer(),
                        MyButton.activity(
                          child: const Text('+100'),
                          onPressed: () => moveSelectedRecord(amount: 100),
                        ),
                        const Spacer(),
                      ]),
                    ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      MyButton.activity(
                          child: const Text('Select as start'),
                          onPressed: () {
                            if (interval.lastRecordId == 0 ||
                                (selectedRecord!.id! <
                                    interval.lastRecordId!)) {
                              interval.firstRecordId = selectedRecord!.id;
                              interval.firstDistance = selectedRecord!.distance;
                              setState(() {});
                            }
                          }),
                      const Spacer(),
                      if (interval.firstRecordId == 0)
                        const Text('No start record selected'),
                      if (interval.firstRecordId! > 0)
                        Text('Selected: ' +
                            interval.firstDistance!.round().toString() +
                            ' m'),
                      const Spacer(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      MyButton.activity(
                        child: const Text('Select as end'),
                        onPressed: () {
                          if (interval.firstRecordId == 0 ||
                              (selectedRecord!.id! > interval.firstRecordId!)) {
                            interval.lastRecordId = selectedRecord!.id;
                            interval.lastDistance = selectedRecord!.distance;
                            setState(() {});
                          }
                        },
                      ),
                      const Spacer(),
                      if (interval.lastRecordId == 0)
                        const Text('No end record selected'),
                      if (interval.lastRecordId! > 0)
                        Text('Selected: ' +
                            interval.lastDistance!.round().toString() +
                            ' m'),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            if (interval.firstDistance! > 0 && interval.lastDistance! > 0)
              Row(
                children: <Widget>[
                  const Spacer(),
                  MyButton.save(
                    child: const Text('Save interval'),
                    onPressed: saveInterval,
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            if (selectedRecord == null)
              const Text('Select a record to continue.'),
          ],
        ),
      );
    } else {
      return GraphUtils.loadingContainer;
    }
  }

  void moveSelectedRecord({required int amount}) {
    if (amount < 0) {
      final int newSelectedRecordId =
          max(selectedRecord!.id! + amount, widget.records!.first.id!);
      selectedRecord = widget.records!
          .firstWhere((Event record) => record.id == newSelectedRecordId);
    } else {
      final int newSelectedRecordId =
          min(selectedRecord!.id! + amount, widget.records!.last.id!);
      selectedRecord = widget.records!
          .firstWhere((Event record) => record.id == newSelectedRecordId);
    }
    setState(() {});
  }

  Future<void> saveInterval() async {
    final RecordList<Event> records = RecordList<Event>(widget.records!
        .where((Event record) =>
            record.id! >= interval.firstRecordId! &&
            record.id! <= interval.lastRecordId!)
        .toList());
    await interval.calculateAndSave(records: records);
    await interval.autoTagger(athlete: widget.athlete);
    widget.activity!.cachedIntervals = <encrateia.Interval>[];
    interval = encrateia.Interval();
    getData();
  }

  Future<void> getData() async {
    interval.athletesId = widget.athlete!.id;
    interval.activitiesId = widget.activity!.id;
    laps = await widget.activity!.laps;
    setState(() {});
  }
}
