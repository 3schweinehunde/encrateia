import 'package:flutter/material.dart';
import '/models/activity.dart';
import '/models/athlete.dart';
import '/models/event.dart';
import '/models/record_list.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/ftp_chart.dart';

class ActivityFtpWidget extends StatefulWidget {
  const ActivityFtpWidget({
    Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  ActivityFtpWidgetState createState() => ActivityFtpWidgetState();
}

class ActivityFtpWidgetState extends State<ActivityFtpWidget> {
  bool loading = true;
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power! > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        return Column(
          children: <Widget>[
            RepaintBoundary(
              key: widgetKey,
              child: FtpChart(records: powerRecords),
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
          child: Text('No power data available.'),
        );
      }
    } else {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(loading ? 'Loading' : 'No data available'),
        ),
      );
    }
  }

  Future<void> getData() async {
    records = RecordList<Event>(await widget.activity!.records);
    setState(() => loading = false);
  }
}
