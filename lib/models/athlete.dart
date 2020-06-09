import 'dart:io';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/model/model.dart'
    show
        DbActivity,
        DbAthlete,
        DbHeartRateZoneSchema,
        DbPowerZoneSchema,
        DbTagGroup,
        DbWeight;
import 'package:path_provider/path_provider.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart' show BoolResult;
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/weight.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'heart_rate_zone_schema.dart';

class Athlete {
  Athlete();
  Athlete._fromDb(this._db);

  String email;
  String password;

  DbAthlete _db = DbAthlete();
  List<int> filters = <int>[];

  int get id => _db?.id;
  String get firstName => _db.firstName;
  String get geoState => _db.geoState;
  String get lastName => _db.lastName;
  String get photoPath => _db.photoPath;
  String get state => _db.state;
  String get stravaUsername => _db.stravaUsername;
  int get downloadInterval => _db.downloadInterval;
  int get recordAggregationCount => _db.recordAggregationCount;
  int get stravaId => _db.stravaId;

  set downloadInterval(int value) => _db.downloadInterval = value;
  set firstName(String value) => _db.firstName = value;
  set lastName(String value) => _db.lastName = value;
  set recordAggregationCount(int value) => _db.recordAggregationCount = value;

  @override
  String toString() => '< Athlete | $firstName $lastName | $stravaId >';

  Future<void> updateFromStravaAthlete(DetailedAthlete athlete) async {
    _db
      ..firstName = athlete.firstname
      ..lastName = athlete.lastname
      ..stravaId = athlete.id
      ..stravaUsername = athlete.username
      ..photoPath = athlete.profile
      ..geoState = athlete.state
      ..state = 'fromStrava'
      ..downloadInterval = 21
      ..recordAggregationCount = 16;
    await save();
  }

  Future<void> setupStandaloneAthlete() async {
    _db
      ..state = 'standalone'
      ..firstName = 'Jane'
      ..lastName = 'Doe'
      ..downloadInterval = 21
      ..recordAggregationCount = 16;
    await save();
  }

  String get stateText {
    switch (state) {
      case 'new':
        return 'Loading athlete data from Strava ...';
      case 'unsaved':
        return 'Strava data loaded successfully.';
      case 'fromStrava':
        return 'Data received from Strava.';
      default:
        return 'Unknown state $state, should have never come here.';
    }
  }

  Future<void> storeCredentials() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: 'email-$stravaId', value: email);
    await storage.write(key: 'password-$stravaId', value: password);
  }

  Future<void> readCredentials() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    email = await storage.read(key: 'email-$stravaId');
    password = await storage.read(key: 'password-$stravaId');
  }

  static Future<List<Athlete>> all() async {
    final List<DbAthlete> dbAthleteList = await DbAthlete().select().toList();
    return dbAthleteList.map(Athlete.exDb).toList();
  }

  Future<List<Activity>> get activities async {
    final List<DbActivity> dbActivityList =
        await _db.getDbActivities().orderByDesc('stravaId').toList();
    return dbActivityList.map(Activity.exDb).toList();
  }

  Future<List<Weight>> get weights async {
    final List<DbWeight> dbWeightList =
        await _db.getDbWeights().orderByDesc('date').toList();
    return dbWeightList.map(Weight.exDb).toList();
  }

  Future<List<PowerZoneSchema>> get powerZoneSchemas async {
    final List<DbPowerZoneSchema> dbPowerZoneSchemaList =
        await _db.getDbPowerZoneSchemas().orderByDesc('date').toList();
    return dbPowerZoneSchemaList.map(PowerZoneSchema.exDb).toList();
  }

  Future<List<HeartRateZoneSchema>> get heartRateZoneSchemas async {
    final List<DbHeartRateZoneSchema> dbHeartRateZoneSchemaList =
        await _db.getDbHeartRateZoneSchemas().orderByDesc('date').toList();
    return dbHeartRateZoneSchemaList.map(HeartRateZoneSchema.exDb).toList();
  }

  Future<List<TagGroup>> get tagGroups async {
    final List<DbTagGroup> dbTagGroupList =
        await _db.getDbTagGroups().orderBy('name').toList();
    final List<TagGroup> tagGroups = dbTagGroupList.map(TagGroup.exDb).toList();

    for (final TagGroup tagGroup in tagGroups) {
      tagGroup.cachedTags = await tagGroup.tags;
    }
    return tagGroups;
  }

  Future<BoolResult> delete() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    for (final Activity activity in await activities) {
      await activity.deleteEvents();
      await activity.deleteLaps();

      // ignore: avoid_slow_async_io
      if (await File(appDocDir.path + '/$stravaId.fit').exists())
        await File(appDocDir.path + '/$stravaId.fit').delete();
    }
    await _db.getDbActivities().delete();
    return await _db.delete();
  }

  Future<int> save() async => await _db.save();

  Future<bool> checkForSchemas() async =>
      (await powerZoneSchemas).isNotEmpty &&
      (await heartRateZoneSchemas).isNotEmpty;

  static Athlete exDb(DbAthlete db) => Athlete._fromDb(db);
}
