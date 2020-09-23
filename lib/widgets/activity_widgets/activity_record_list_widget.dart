import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/screens/show_event_screen.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class ActivityRecordListWidget extends StatefulWidget {
  const ActivityRecordListWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityRecordListWidgetState createState() =>
      _ActivityRecordListWidgetState();
}

class _ActivityRecordListWidgetState extends State<ActivityRecordListWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      rows = (records.length < 8) ? records.length : 8;
      final DateTime startingTime = records.first.timeStamp;
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
                  DataColumn(
                    label: Text('Distance'),
                    numeric: true,
                  ),
                  DataColumn(label: Text('Details')),
                ],
                rows:
                    records.sublist(offset, offset + rows).map((Event record) {
                  return DataRow(
                    key: ValueKey<int>(record.id),
                    cells: <DataCell>[
                      DataCell(PQText(
                        value: record.timeStamp,
                        pq: PQ.dateTime,
                        format: DateTimeFormat.longDateTime,
                      )),
                      DataCell(PQText(
                        value:
                            record.timeStamp.difference(startingTime).inSeconds,
                        pq: PQ.duration,
                      )),
                      DataCell(PQText(
                          value: record.distance, pq: PQ.distanceInMeters)),
                      DataCell(
                        MyIcon.show,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                                builder: (BuildContext context) =>
                                    ShowEventScreen(record: record)),
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
                  'of ${records.length} (Page ${(offset / 8).round() + 1} of ${(records.length / 8).round()})',
                  textAlign: TextAlign.right,
                ),
              ),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10),
                  MyButton.navigate(
                      child: const Text('|<'),
                      onPressed: (offset == 0)
                          ? null
                          : () => setState(() => offset = 0)),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    child: const Text('<'),
                    onPressed: (offset == 0)
                        ? null
                        : () => setState(() {
                              offset > 8 ? offset = offset - rows : offset = 0;
                            }),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    child: const Text('>'),
                    onPressed: (offset + rows == records.length)
                        ? null
                        : () => setState(() {
                              offset + rows < records.length - rows
                                  ? offset = offset + rows
                                  : offset = records.length - rows;
                            }),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    child: const Text('|>'),
                    onPressed: (offset + rows == records.length)
                        ? null
                        : () => setState(() => offset = records.length - rows),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    child: const Text('100 <'),
                    onPressed: (offset == 0)
                        ? null
                        : () => setState(() {
                              offset > 800
                                  ? offset = offset - 100 * rows
                                  : offset = 0;
                            }),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    child: const Text('10 <'),
                    onPressed: (offset == 0)
                        ? null
                        : () => setState(() {
                              offset > 80
                                  ? offset = offset - 10 * rows
                                  : offset = 0;
                            }),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    child: const Text('10 >'),
                    onPressed: (offset + rows == records.length)
                        ? null
                        : () => setState(() {
                              offset + 10 * rows < records.length - rows
                                  ? offset = offset + 10 * rows
                                  : offset = records.length - rows;
                            }),
                  ),
                  const SizedBox(width: 10),
                  MyButton.navigate(
                    child: const Text('100 >'),
                    onPressed: (offset + rows == records.length)
                        ? null
                        : () => setState(() {
                              offset + 100 * rows < records.length - rows
                                  ? offset = offset + 100 * rows
                                  : offset = records.length - rows;
                            }),
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
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    setState(() {});
  }
}
