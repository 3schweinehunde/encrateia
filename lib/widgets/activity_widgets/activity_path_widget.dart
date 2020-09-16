import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/image_utils.dart';
import 'package:encrateia/utils/my_button.dart';
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
  bool loading = true;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String screenShotButtonText = 'Save as .png-Image';
    final GlobalKey widgetKey = GlobalKey();

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
                  await ImageUtils.capturePng(widgetKey: widgetKey);
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
