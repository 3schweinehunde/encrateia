import 'package:flutter/material.dart';

import '/models/event.dart';
import '/models/lap.dart';
import '/models/record_list.dart';
import '/utils/PQText.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/image_utils.dart' as image_utils;
import '/utils/my_button.dart';
import '/widgets/charts/lap_charts/lap_form_power_chart.dart';

class LapFormPowerWidget extends StatefulWidget {
  const LapFormPowerWidget({this.lap});

  final Lap? lap;

  @override
  _LapFormPowerWidgetState createState() => _LapFormPowerWidgetState();
}

class _LapFormPowerWidgetState extends State<LapFormPowerWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  bool loading = true;
  String screenShotButtonText = 'Save as .png-Image';
  GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapFormPowerWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty) {
      final List<Event> formPowerRecords = records
          .where(
              (Event value) => value.formPower != null && value.formPower! > 0)
          .toList();

      if (formPowerRecords.isNotEmpty) {
        return ListTileTheme(
          iconColor: Colors.lightGreen,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              RepaintBoundary(
                key: widgetKey,
                child: LapFormPowerChart(
                  records: RecordList<Event>(formPowerRecords),
                  minimum: widget.lap!.avgFormPower! / 1.1,
                  maximum: widget.lap!.avgFormPower! * 1.25,
                ),
              ),
              const Text(
                  'Only records where 0 W < form power < 200 W are shown.'),
              const Text('Swipe left/write to compare with other laps.'),
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
              ListTile(
                leading: MyIcon.average,
                title: PQText(value: widget.lap!.avgFormPower, pq: PQ.power),
                subtitle: const Text('average form power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: PQText(value: widget.lap!.sdevFormPower, pq: PQ.power),
                subtitle: const Text('standard deviation form power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: PQText(value: formPowerRecords.length, pq: PQ.integer),
                subtitle: const Text('number of measurements'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No form power data available.'),
        );
      }
    } else {
      return Center(
        child: Text(loading ? 'Loading' : 'No data available'),
      );
    }
  }

  Future<void> getData() async {
    final Lap lap = widget.lap!;
    records = RecordList<Event>(await (lap.records as FutureOr<List<Event>>));
    setState(() => loading = false);
  }
}
