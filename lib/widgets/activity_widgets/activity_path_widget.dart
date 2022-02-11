import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/utils/my_path.dart';

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
  bool loading = true;
  String screenShotButtonText = 'Save as .png-Image';
  final GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> geoRecords = records
          .where((Event value) =>
              value.positionLong != null && value.positionLat != null)
          .toList();

      if (geoRecords.isNotEmpty && geoRecords != null) {
        return Column(
          children: <Widget>[
            RepaintBoundary(
              key: widgetKey,
              child: MyPath(
                activity: widget.activity,
                records: RecordList<Event>(geoRecords),
              ),
            ),
            Row(children: <Widget>[
              const Spacer(),
              MyButton.save(
                child: Text(screenShotButtonText),
                onPressed: () async {
                  await image_utils.capturePng(widgetKey: widgetKey);
                  screenShotButtonText = 'Image saved';
                  setState(() {});
                },
              ),
              const SizedBox(width: 20),
            ]),
          ],
        );
      } else {
        return const Center(
          child: Text('No coordinates available'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'no records found'),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity.records);
    setState(() => loading = false);
  }
}
