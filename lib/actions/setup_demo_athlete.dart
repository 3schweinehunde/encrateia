import 'package:flutter/material.dart';
import '/actions/download_demo_data.dart';
import '/models/athlete.dart';
import '/models/heart_rate_zone_schema.dart';
import '/models/power_zone_schema.dart';
import '/models/weight.dart';

Future<void> setupDemoAthlete({
  required BuildContext context,
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
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}
