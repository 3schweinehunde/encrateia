import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/utils/num_utils.dart';
import 'package:encrateia/widgets/charts/activity_charts/activity_power_chart.dart';
import 'package:encrateia/utils/icon_utils.dart';

class ActivityPowerWidget extends StatefulWidget {
  const ActivityPowerWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityPowerWidgetState createState() => _ActivityPowerWidgetState();
}

class _ActivityPowerWidgetState extends State<ActivityPowerWidget> {
  RecordList<Event> records = RecordList<Event>(<Event>[]);
  String avgPowerString = 'Loading ...';
  String minPowerString = 'Loading ...';
  String maxPowerString = 'Loading ...';
  String sdevPowerString = 'Loading ...';
  PowerZoneSchema powerZoneSchema;
  List<PowerZone> powerZones;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (records.isNotEmpty && powerZones != null) {
      final List<Event> powerRecords = records
          .where((Event value) => value.power != null && value.power > 100)
          .toList();

      if (powerRecords.isNotEmpty) {
        final Event lastRecord = powerRecords.last;
        return ListTileTheme(
          iconColor: Colors.deepOrange,
          child: ListView(
            padding: const EdgeInsets.only(left: 25),
            children: <Widget>[
              ActivityPowerChart(
                records: RecordList<Event>(powerRecords),
                activity: widget.activity,
                powerZones: powerZones,
                athlete: widget.athlete,
              ),
              Text('${widget.athlete.recordAggregationCount} records are '
                  'aggregated into one point in the plot. Only records where '
                  'power > 100 W are shown.'),
              const Divider(),
              ListTile(
                leading: MyIcon.average,
                title: Text(avgPowerString),
                subtitle: const Text('average power'),
              ),
              ListTile(
                leading: MyIcon.minimum,
                title: Text(minPowerString),
                subtitle: const Text('minimum power'),
              ),
              ListTile(
                leading: MyIcon.maximum,
                title: Text(maxPowerString),
                subtitle: const Text('maximum power'),
              ),
              ListTile(
                leading: MyIcon.standardDeviation,
                title: Text(sdevPowerString),
                subtitle: const Text('standard deviation power'),
              ),
              ListTile(
                leading: MyIcon.amount,
                title: Text(powerRecords.length.toString()),
                subtitle: const Text('number of measurements'),
              ),
              ListTile(
                leading: const Text('🕵️‍♀️', style: TextStyle(fontSize: 25)),
                title: Text(lastRecord.positionLong.semicirclesAsDegrees() +
                    ' / ' +
                    lastRecord.positionLat.semicirclesAsDegrees()),
                subtitle: const Text('findYourStryd (last power record)'),
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('No power data available.'),
        );
      }
    } else {
      return const Center(
        child: Text('Loading'),
      );
    }
  }

  Future<void> getData() async {
    final Activity activity = widget.activity;
    records = RecordList<Event>(await activity.records);
    avgPowerString = activity.db.avgPower.toStringOrDashes(1) + ' W';
    minPowerString = activity.db.minPower.toString() + ' W';
    maxPowerString = activity.db.maxPower.toString() + ' W';
    sdevPowerString = activity.db.sdevPower.toStringOrDashes(2) + ' W';

    powerZoneSchema = await activity.powerZoneSchema;
    if (powerZoneSchema != null)
      powerZones = await powerZoneSchema.powerZones;
    else
      powerZones = <PowerZone>[];
    setState(() {});
  }
}
