import 'package:encrateia/actions/download_demo_data.dart';
import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Future<void> setupDemoAthlete({
  @required BuildContext context,
  @required Flushbar<Object> flushbar,
}) async {
  final Athlete athlete = Athlete();
  await athlete.setupStandaloneAthlete();

  final PowerZoneSchema powerZoneSchema =
      PowerZoneSchema.likeStryd(athlete: athlete);
  await powerZoneSchema.save();
  await powerZoneSchema.addStrydZones();

  final HeartRateZoneSchema heartRateZoneSchema =
      HeartRateZoneSchema.likeGarmin(athlete: athlete);
  await heartRateZoneSchema.save();
  await heartRateZoneSchema.addGarminZones();

  final Weight weight = Weight(athlete: athlete);
  weight.date = DateTime(2015);
  await weight.save();

  await downloadDemoData(
    context: context,
    athlete: athlete,
    flushbar: flushbar,
  );
}
