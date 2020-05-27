import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class ActivityBarGraphWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityBarGraphWidget({
    @required this.activity,
    @required this.athlete,
  });

  @override
  _ActivityBarGraphWidgetState createState() => _ActivityBarGraphWidgetState();
}

class _ActivityBarGraphWidgetState extends State<ActivityBarGraphWidget> {
  PowerZoneSchema _powerZoneSchema;
  HeartRateZoneSchema _heartRateZoneSchema;
  List<PowerZone> _powerZones = [];
  List<HeartRateZoneSchema> _heartRateZones = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    return Text("hi!");
  }

  getData() async {
    Activity activity = widget.activity;

    _powerZoneSchema = await activity.powerZoneSchema;
    if (_powerZoneSchema != null)
      _powerZones = await _powerZoneSchema.powerZones;
    print(_powerZones.length);

    _heartRateZoneSchema = await activity.heartRateZoneSchema;
    if (_heartRateZoneSchema != null)
      _heartRateZoneSchema = await _heartRateZoneSchema.heartRateZones;
    print(_heartRateZones.length);

    setState(() {});
  }
}
