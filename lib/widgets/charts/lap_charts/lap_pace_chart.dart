import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

import '/models/event.dart';
import '/models/record_list.dart';
import '/screens/show_event_screen.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/graph_utils.dart';
import '/utils/my_button.dart';

class LapPaceChart extends StatefulWidget {
  const LapPaceChart({Key? key,
    required this.records,
    required this.minimum,
    required this.maximum,
  }) : super(key: key);

  final RecordList<Event> records;
  final double minimum;
  final double maximum;

  @override
  _LapPaceChartState createState() => _LapPaceChartState();
}

class _LapPaceChartState extends State<LapPaceChart> {
  Event? selectedEvent;

  void _onSelectionChanged(SelectionModel<num> model) {
    final List<SeriesDatum<dynamic>> selectedDatum = model.selectedDatum;

    if (selectedDatum.isNotEmpty) {
      setState(() => selectedEvent = selectedDatum[0].datum as Event?);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int offset = widget.records.first.distance!.round();
    final DateTime? startingTime = widget.records.first.timeStamp;

    final List<Series<Event, int>> data = <Series<Event, int>>[
      Series<Event, int>(
        id: 'Pace',
        colorFn: (_, __) => MaterialPalette.black,
        domainFn: (Event record, _) => record.distance!.round() - offset,
        measureFn: (Event record, _) => 50 / 3 / record.speed!,
        data: widget.records,
      )
    ];

    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio:
            MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
        child: LineChart(
          data,
          defaultRenderer: LineRendererConfig<num>(
            includeArea: true,
            strokeWidthPx: 1,
          ),
          primaryMeasureAxis: NumericAxisSpec(
            tickProviderSpec: const BasicNumericTickProviderSpec(
              zeroBound: false,
              dataIsInWholeNumbers: false,
              desiredTickCount: 5,
            ),
            viewport: NumericExtents(widget.minimum, widget.maximum),
          ),
          animate: false,
          behaviors: GraphUtils.axis(
            measureTitle: 'Pace (min/km)',
          ),
          flipVerticalAxis: true,
          selectionModels: <SelectionModelConfig<num>>[
            SelectionModelConfig<num>(
              type: SelectionModelType.info,
              changedListener: _onSelectionChanged,
            )
          ],
        ),
      ),
      if (selectedEvent != null)
        Column(
          children: <Widget>[
            const Divider(),
            const Text('Selected Record:'),
            ListTile(
              title: PQText(
                value: selectedEvent!.timeStamp,
                pq: PQ.dateTime,
                format: DateTimeFormat.longDateTime,
              ),
              subtitle: const Text('Point in time'),
            ),
            ListTile(
              title: PQText(
                value:
                    selectedEvent!.timeStamp!.difference(startingTime!).inSeconds,
                pq: PQ.duration,
              ),
              subtitle: const Text('Time elapsed'),
            ),
            ListTile(
              title: PQText(
                  value: selectedEvent!.distance, pq: PQ.distanceInMeters),
              subtitle: const Text('Distance'),
            ),
            MyButton.detail(
              child: const Text('Details'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) =>
                          ShowEventScreen(record: selectedEvent)),
                );
              },
            ),
            const Divider(),
          ],
        )
    ]);
  }
}
