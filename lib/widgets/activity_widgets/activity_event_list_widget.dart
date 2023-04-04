import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/screens/show_event_screen.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button.dart';

class ActivityEventListWidget extends StatefulWidget {
  const ActivityEventListWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityEventListWidgetState createState() =>
      _ActivityEventListWidgetState();
}

class _ActivityEventListWidgetState extends State<ActivityEventListWidget> {
  RecordList<Event> events = RecordList<Event>(<Event>[]);
  bool loading = true;
  int offset = 0;
  late int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (events.isNotEmpty) {
      rows = (events.length < 8) ? events.length : 8;
      final DateTime? startingTime = events.first.timeStamp;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DataTable(
                columnSpacing: 10,
                columns: const <DataColumn>[
                  DataColumn(label: Text('Point in time')),
                  DataColumn(label: Text('Time elapsed')),
                  DataColumn(label: Text('Type')),
                  DataColumn(
                    label: Text('Distance'),
                    numeric: true,
                  ),
                  DataColumn(label: Text('Details')),
                ],
                rows: events.sublist(offset, offset + rows).map((Event event) {
                  return DataRow(
                    key: ValueKey<int?>(event.id),
                    cells: <DataCell>[
                      DataCell(PQText(
                        value: event.timeStamp,
                        pq: PQ.dateTime,
                        format: DateTimeFormat.longDateTime,
                      )),
                      DataCell(PQText(
                        value: event.timeStamp!
                            .difference(startingTime!)
                            .inSeconds,
                        pq: PQ.duration,
                      )),
                      DataCell(PQText(value: event.eventType, pq: PQ.text)),
                      DataCell(PQText(
                        value: event.distance,
                        pq: PQ.distanceInMeters,
                      )),
                      DataCell(
                        MyIcon.show,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                                builder: (BuildContext context) =>
                                    ShowEventScreen(record: event)),
                          );
                          getData();
                        },
                      )
                    ],
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${offset + 1} - ${offset + rows} '
                  'of ${events.length} (Page ${(offset / 8).round() + 1} of ${(events.length / 8).round()})',
                  textAlign: TextAlign.right,
                ),
              ),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10),
                  MyButton.navigate(
                      onPressed: (offset == 0)
                          ? null
                          : () => setState(() => offset = 0),
                      child: const Text('|<')),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    onPressed: (offset == 0)
                        ? null
                        : () => setState(() {
                              offset > 8 ? offset = offset - rows : offset = 0;
                            }),
                    child: const Text('<'),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    onPressed: (offset + rows == events.length)
                        ? null
                        : () => setState(() {
                              offset + rows < events.length - rows
                                  ? offset = offset + rows
                                  : offset = events.length - rows;
                            }),
                    child: const Text('>'),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    onPressed: (offset + rows == events.length)
                        ? null
                        : () => setState(() => offset = events.length - rows),
                    child: const Text('|>'),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    onPressed: (offset == 0)
                        ? null
                        : () => setState(() {
                              offset > 800
                                  ? offset = offset - 100 * rows
                                  : offset = 0;
                            }),
                    child: const Text('100 <'),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    onPressed: (offset == 0)
                        ? null
                        : () => setState(() {
                              offset > 80
                                  ? offset = offset - 10 * rows
                                  : offset = 0;
                            }),
                    child: const Text('10 <'),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    onPressed: (offset + rows == events.length)
                        ? null
                        : () => setState(() {
                              offset + 10 * rows < events.length - rows
                                  ? offset = offset + 10 * rows
                                  : offset = events.length - rows;
                            }),
                    child: const Text('10 >'),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    onPressed: (offset + rows == events.length)
                        ? null
                        : () => setState(() {
                              offset + 100 * rows < events.length - rows
                                  ? offset = offset + 100 * rows
                                  : offset = events.length - rows;
                            }),
                    child: const Text('100 >'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'no records found'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity!;
    events = RecordList<Event>(await activity.events);
    setState(() {});
  }
}
