import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/my_path.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';

class ActivityPathWidget extends StatefulWidget {
  const ActivityPathWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityPathWidgetState createState() => _ActivityPathWidgetState();
}

class _ActivityPathWidgetState extends State<ActivityPathWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> ecorRecords = records
          .where((Event value) =>
              value.db.power != null &&
              value.db.power > 100 &&
              value.db.speed != null &&
              value.db.speed >= 1)
          .toList();

      if (ecorRecords.isNotEmpty && ecorRecords != null) {
        return Center(
          child: MyPath(
            activity: widget.activity,
            records: records,
          ),
        );
      } else {
        return const Center(
          child: Text('No ecor data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity.records);
    setState(() {});
  }
}
