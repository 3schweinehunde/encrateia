import 'dart:io';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/model/model.dart' show DbAthlete;
import 'package:path_provider/path_provider.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/weight.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'heart_rate_zone_schema.dart';

class Athlete {
  Athlete();
  Athlete.fromDb(this.db);

  String email;
  String password;
  String firstName;
  String lastName;
  DbAthlete db = DbAthlete();
  List<int> filters = <int>[];

  @override
  String toString() =>
      '< Athlete | ${db.firstName} ${db.lastName} | ${db.stravaId} >';

  void updateFromStravaAthlete(DetailedAthlete athlete) {
    db
      ..firstName = athlete.firstname
      ..lastName = athlete.lastname
      ..stravaId = athlete.id
      ..stravaUsername = athlete.username
      ..photoPath = athlete.profile
      ..geoState = athlete.state
      ..state = 'fromStrava'
      ..downloadInterval = 21
      ..recordAggregationCount = 16;
  }

  Future<void> setupStandaloneAthlete() async {
    db
      ..state = 'standalone'
      ..firstName = 'Jane'
      ..lastName = 'Doe'
      ..downloadInterval = 21
      ..recordAggregationCount = 16;
    await db.save();
  }

  String get stateText {
    switch (db.state) {
      case 'new':
        return 'Loading athlete data from Strava ...';
      case 'unsaved':
        return 'Strava data loaded successfully.';
      case 'fromStrava':
        return 'Data received from Strava.';
      default:
        return 'Unknown state ${db.state}, should have never come here.';
    }
  }

  Future<void> storeCredentials() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }

  Future<void> readCredentials() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    email = await storage.read(key: 'email');
    password = await storage.read(key: 'password');
  }

  static Future<List<Athlete>> all() async {
    final List<DbAthlete> dbAthleteList = await DbAthlete().select().toList();
    return dbAthleteList
        .map((DbAthlete dbAthlete) => Athlete.fromDb(dbAthlete))
        .toList();
  }

  Future<List<Activity>> get activities => Activity.all(athlete: this);
  Future<List<Weight>> get weights => Weight.all(athlete: this);
  Future<List<PowerZoneSchema>> get powerZoneSchemas =>
      PowerZoneSchema.all(athlete: this);
  Future<List<HeartRateZoneSchema>> get heartRateZoneSchemas =>
      HeartRateZoneSchema.all(athlete: this);
  Future<List<TagGroup>> get tagGroups => TagGroup.all(athlete: this);

  Future<void> delete() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    for (final Activity activity in await activities) {
      await activity.db.getDbEvents().delete();
      await activity.db.getDbLaps().delete();

      // ignore: avoid_slow_async_io
      if (await File(appDocDir.path + '/${db.stravaId}.fit').exists())
        await File(appDocDir.path + '/${db.stravaId}.fit').delete();
    }
    await db.getDbActivities().delete();
    await db.delete();
  }

  Future<void> save() async => await db.save();

  Future<bool> checkForSchemas() async =>
      (await powerZoneSchemas).isNotEmpty &&
      (await heartRateZoneSchemas).isNotEmpty;
}
