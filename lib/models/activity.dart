import 'dart:developer';
import 'dart:io';
import 'package:encrateia/models/power_zone.dart';
import 'package:encrateia/models/strava_fit_download.dart';
// ignore: implementation_imports
import 'package:fit_parser/src/value.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart'
    show DbActivity, DbEvent, DbHeartRateZone, DbPowerZone;
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:strava_flutter/strava.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/Models/activity.dart' as strava_activity;
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/record_list.dart';
import 'package:encrateia/models/event.dart';
import 'package:encrateia/models/lap.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:intl/intl.dart';
import 'package:encrateia/utils/enums.dart';
import 'activity_tagging.dart';
import 'bar_zone.dart';
import 'heart_rate_zone.dart';
import 'heart_rate_zone_schema.dart';

class Activity {
  Activity();
  Activity.fromDb(this.db);

  Activity.fromStrava({
    strava_activity.SummaryActivity summaryActivity,
    Athlete athlete,
  }) {
    db = DbActivity()
      ..athletesId = athlete.db.id
      ..name = summaryActivity.name
      ..type = summaryActivity.type
      ..distance = summaryActivity.distance.toInt()
      ..stravaId = summaryActivity.id
      ..movingTime = summaryActivity.movingTime;
  }

  Activity.fromLocalDirectory({Athlete athlete}) {
    db = DbActivity()
      ..athletesId = athlete.db.id
      ..stravaId = DateTime.now().millisecondsSinceEpoch
      ..name = 't.b.d.';
  }

  DbActivity db;
  List<Event> _records;
  List<Lap> _laps;
  List<Tag> cachedTags = <Tag>[];
  double glidingMeasureAttribute;
  double weight;
  PowerZoneSchema _powerZoneSchema;
  PowerZone _powerZone;
  HeartRateZone _heartRateZone;
  HeartRateZoneSchema _heartRateZoneSchema;

  // intermediate data structures used for parsing
  Lap currentLap;
  List<Event> eventsForCurrentLap;

  @override
  String toString() => '< Activity | ${db.name} | ${db.startTime} >';
  Duration movingDuration() => Duration(seconds: db.movingTime ?? 0);

  dynamic getAttribute(ActivityAttr activityAttr) {
    switch (activityAttr) {
      case ActivityAttr.avgPower:
        return db.avgPower;
      case ActivityAttr.ecor:
        return db.avgPower / db.avgSpeed / weight;
      case ActivityAttr.avgPowerPerHeartRate:
        return db.avgPower / db.avgHeartRate;
      case ActivityAttr.avgSpeedPerHeartRate:
        return 100 * (db.avgSpeed / db.avgHeartRate);
      case ActivityAttr.avgPowerRatio:
        return 100 * (db.avgPower - db.avgFormPower) / db.avgPower;
      case ActivityAttr.avgStrideRatio:
        return 10000 /
            6 *
            db.avgSpeed /
            db.avgStrydCadence /
            db.avgVerticalOscillation;
    }
  }

  Future<void> download({@required Athlete athlete}) async {
    await StravaFitDownload.byId(id: db.stravaId.toString(), athlete: athlete);
    setState('downloaded');
  }

  static Future<void> importFromLocalDirectory({Athlete athlete}) async {
    if (Platform.isAndroid) {
      final List<Directory> directories = await getExternalStorageDirectories();
      final Directory localDir = directories[0];
      final Directory appDocDir = await getApplicationDocumentsDirectory();

      final Stream<FileSystemEntity> entityStream = localDir.list(
        recursive: false,
        followLinks: false,
      );

      await for (final FileSystemEntity entity in entityStream) {
        final Activity activity = Activity.fromLocalDirectory(athlete: athlete);
        // ignore: avoid_slow_async_io
        final bool isFile = await FileSystemEntity.isFile(entity.path);
        if (isFile == true && entity.path.endsWith('.fit')) {
          final File sourceFile = File(entity.path);
          await sourceFile.copy(
              appDocDir.path + '/' + activity.db.stravaId.toString() + '.fit');
          sourceFile.delete();
          await activity.setState('downloaded');
        }
      }
    } else {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Stream<FileSystemEntity> entityStream = appDocDir.list(
        recursive: false,
        followLinks: false,
      );

      await for (final FileSystemEntity entity in entityStream) {
        final Activity activity = Activity.fromLocalDirectory(athlete: athlete);
        // ignore: avoid_slow_async_io
        final bool isFile = await FileSystemEntity.isFile(entity.path);
        if (isFile == true && entity.path.endsWith('.fit')) {
          final File sourceFile = File(entity.path);
          await sourceFile.rename(
              appDocDir.path + '/' + activity.db.stravaId.toString() + '.fit');
          await activity.setState('downloaded');
        }
      }
    }
  }

  Future<void> setState(String state) async {
    db.state = state;
    await db.save();
  }

  String distanceString() {
    return db.totalDistance == null
        ? '- - -'
        : (db.totalDistance / 1000).toStringAsFixed(2) + ' km';
  }

  String heartRateString() {
    return (db.avgHeartRate == null || db.avgHeartRate == 255)
        ? '- - -'
        : db.avgHeartRate.toString() + ' bpm';
  }

  String averagePowerString() {
    return (db.avgPower == null || db.avgPower == -1)
        ? '-'
        : db.avgPower.toStringAsFixed(1) + ' W';
  }

  String timeString() {
    return db.timeCreated == null
        ? '- - -'
        : DateFormat('H:mm').format(db.timeCreated);
  }

  String dateString() {
    return db.timeCreated == null
        ? '- - -'
        : DateFormat('d MMM yy').format(db.timeCreated);
  }

  String longDateTimeString() {
    return db.timeCreated == null
        ? '- - -'
        : DateFormat('E d MMM yy, H:mm').format(db.timeCreated);
  }

  String shortDateString() {
    return db.timeCreated == null
        ? '- - -'
        : DateFormat('d.M.').format(db.timeCreated);
  }

  String paceString() => db.avgSpeed.toPace() + '/km';

  Future<List<Event>> get records async {
    return _records ??= await Event.recordsByActivity(activity: this);
  }

  Future<List<Lap>> get laps async {
    return _laps ??= await Lap.all(activity: this);
  }

  Future<List<Tag>> get tags async {
    if (cachedTags.isEmpty) {
      cachedTags = await Tag.allByActivity(activity: this);
    }
    return cachedTags;
  }

  Future<bool> recalculateAverages() async {
    final RecordList<Event> recordList = RecordList<Event>(<Event>[]);
    recordList.addAll(await records);
    db
      ..avgPower = recordList.calculateAveragePower()
      ..sdevPower = recordList.calculateSdevPower()
      ..minPower = recordList.calculateMinPower()
      ..maxPower = recordList.calculateMaxPower()
      ..avgSpeed = recordList.calculateAverageSpeed()
      ..avgGroundTime = recordList.calculateAverageGroundTime()
      ..sdevGroundTime = recordList.calculateSdevGroundTime()
      ..avgVerticalOscillation =
          recordList.calculateAverageVerticalOscillation()
      ..sdevVerticalOscillation = recordList.calculateSdevVerticalOscillation()
      ..avgStrydCadence = recordList.calculateAverageStrydCadence()
      ..sdevStrydCadence = recordList.calculateSdevStrydCadence()
      ..avgLegSpringStiffness = recordList.calculateAverageLegSpringStiffness()
      ..sdevLegSpringStiffness = recordList.calculateSdevLegSpringStiffness()
      ..avgFormPower = recordList.calculateAverageFormPower()
      ..sdevFormPower = recordList.calculateSdevFormPower()
      ..avgPowerRatio = recordList.calculateAveragePowerRatio()
      ..sdevPowerRatio = recordList.calculateSdevPowerRatio()
      ..avgStrideRatio = recordList.calculateAverageStrideRatio()
      ..sdevStrideRatio = recordList.calculateSdevStrideRatio();

    final List<Lap> laps = await this.laps;
    for (final Lap lap in laps) {
      await lap.averages();
    }
    await db.save();
    return true;
  }

  Stream<int> parse({@required Athlete athlete}) async* {
    int counter = 0;
    int percentage;

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final FitFile fitFile =
        FitFile(path: appDocDir.path + '/${db.stravaId}.fit').parse();
    print('Parsing .fit-File for »${db.name}« done.');

    // delete left overs from prior runs:
    await db.getDbEvents().delete();
    await db.getDbLaps().delete();
    db
      ..avgPower = null
      ..minPower = null
      ..maxPower = null
      ..sdevPower = null
      ..avgGroundTime = null
      ..sdevGroundTime = null
      ..avgLegSpringStiffness = null
      ..sdevLegSpringStiffness = null
      ..avgFormPower = null
      ..sdevFormPower = null
      ..avgStrydCadence = null
      ..sdevStrydCadence = null
      ..sdevVerticalOscillation = null;
    await db.save();

    final int numberOfMessages = fitFile.dataMessages.length;
    await resetCurrentLap();

    for (final DataMessage dataMessage in fitFile.dataMessages) {
      counter++;
      percentage = await handleDataMessage(dataMessage: dataMessage);

      if (counter % 100 == 0) {
        percentage = (counter / numberOfMessages * 100).round();
        yield percentage;
      }
    }

    db.state = 'persisted';
    await recalculateAverages();
    await db.save();
    print('Activity data for »${db.name}« stored in database.');
    yield 100;
  }

  Future<int> handleDataMessage({DataMessage dataMessage}) async {
    if (dataMessage.definitionMessage.globalMessageName == null) {
      switch (dataMessage.definitionMessage.globalMessageNumber) {
        // Garmin Forerunner 235uses global message numbers, which are not specified:
        case 13:
        case 22:
        case 79:
        case 104:
        case 113:
        case 140:
        case 141:
        case 147:
        case 216:
        // Garmin Forerunner 935 uses global message numbers, which are not specified:
        case 233:
        // Garmin Forerunner 245 Music uses global message numbers, which are not specified:
        case 288:
        case 325:
        case 326:
        case 327:
          break;
        default:
          print('Message number ' +
              dataMessage.definitionMessage.globalMessageNumber.toString() +
              'unknown.');
          debugger();
      }
    } else {
      switch (dataMessage.definitionMessage.globalMessageName) {
        case 'developer_data_id':
        case 'device_info':
        case 'device_settings':
        case 'field_description':
        case 'file_creator':
        case 'user_profile':
        case 'zones_target':
          break; // we are currently not storing these kinds of messages

        case 'file_id':
          db
            ..serialNumber =
                (dataMessage.get('serial_number') as double)?.round()
            ..timeCreated =
                dateTimeFromStrava(dataMessage.get('time_created') as double);
          await db.save();
          break;

        case 'sport':
          db
            ..sportName = dataMessage.get('name') as String
            ..sport = dataMessage.get('sport') as String
            ..subSport = dataMessage.get('sub_sport') as String;
          await db.save();
          break;

        case 'event':
          final Event event = Event(
            dataMessage: dataMessage,
            activity: this,
          );
          eventsForCurrentLap.add(event);
          break;

        case 'record':
          final Event event = Event.fromRecord(
            dataMessage: dataMessage,
            activity: this,
            lapsId: currentLap.db.id,
          );
          eventsForCurrentLap.add(event);
          break;

        case 'lap':
          final Event event = Event.fromLap(
            dataMessage: dataMessage,
            activity: this,
            lapsId: currentLap.db.id,
          );
          eventsForCurrentLap.add(event);

          final Lap lap = Lap.fromLap(
            dataMessage: dataMessage,
            activity: this,
            lap: currentLap,
          );
          await lap.db.save();
          await DbEvent().upsertAll(eventsForCurrentLap
              .where((Event event) => event.db != null)
              .map((Event event) => event.db)
              .toList());

          await resetCurrentLap();
          break;

        case 'segment_lap':
        case 'gps_metadata':
        case 'training_file':
        case 'workout':
        case 'workout_step':
          break;

        case 'session':
          final DateTime startTime =
              dateTimeFromStrava(dataMessage.get('start_time') as double);

          if (db.name == 't.b.d.')
            db.name =
                'Activity on ' + DateFormat.yMMMMd('en_US').format(startTime);
          db
            ..timeStamp =
                dateTimeFromStrava(dataMessage.get('timestamp') as double)
            ..startTime = startTime
            ..startPositionLat = dataMessage.get('start_position_lat') as double
            ..startPositionLong =
                dataMessage.get('start_position_long') as double
            ..totalElapsedTime =
                (dataMessage.get('total_elapsed_time') as double)?.round()
            ..totalTimerTime =
                (dataMessage.get('total_timer_time') as double)?.round()
            ..distance = (db.distance ??
                (dataMessage.get('total_distance') as double)?.round())
            ..totalDistance =
                (dataMessage.get('total_distance') as double)?.round()
            ..totalStrides =
                (dataMessage.get('total_strides') as double)?.round()
            ..necLat = dataMessage.get('nec_lat') as double
            ..necLong = dataMessage.get('nec_long') as double
            ..swcLat = dataMessage.get('swc_lat') as double
            ..swcLong = dataMessage.get('swc_long') as double
            ..totalCalories =
                (dataMessage.get('total_calories') as double)?.round()
            ..avgSpeed = dataMessage.get('avg_speed') as double
            ..maxSpeed = dataMessage.get('max_speed') as double
            ..totalAscent = (dataMessage.get('total_ascent') as double)?.round()
            ..totalDescent =
                (dataMessage.get('total_descent') as double)?.round()
            ..maxRunningCadence =
                (dataMessage.get('max_running_cadence') as double)?.round()
            ..firstLapIndex =
                (dataMessage.get('first_lap_index') as double)?.round()
            ..numLaps = (dataMessage.get('num_laps') as double)?.round()
            ..event = dataMessage.get('event')?.toString()
            ..type = db.type ?? dataMessage.get('event_type') as String
            ..eventType = dataMessage.get('event_type') as String
            ..eventGroup = (dataMessage.get('event_group') as double)?.round()
            ..trigger = dataMessage.get('trigger') as String
            ..avgVerticalOscillation =
                dataMessage.get('avg_vertical_oscillation') as double
            ..avgStanceTimePercent =
                dataMessage.get('avg_stance_time_percent') as double
            ..avgStanceTime = dataMessage.get('avg_stance_time') as double
            ..sport = dataMessage.get('sport') as String
            ..subSport = dataMessage.get('sub_sport') as String
            ..avgHeartRate =
                (dataMessage.get('avg_heart_rate') as double)?.round()
            ..maxHeartRate =
                (dataMessage.get('max_heart_rate') as double)?.round()
            ..avgRunningCadence =
                dataMessage.get('avg_running_cadence') as double
            ..totalTrainingEffect =
                (dataMessage.get('total_training_effect') as double)?.round()
            ..avgTemperature =
                (dataMessage.get('avg_temperature') as double)?.round()
            ..maxTemperature =
                (dataMessage.get('max_temperature') as double)?.round()
            ..avgFractionalCadence =
                dataMessage.get('avg_fractional_cadence') as double
            ..maxFractionalCadence =
                dataMessage.get('max_fractional_cadence') as double
            ..totalFractionalCycles =
                dataMessage.get('total_fractional_cycles') as double;
          await db.save();
          break;

        case 'activity':
          db
            ..numSessions = (dataMessage.get('num_sessions') as double)?.round()
            ..localTimestamp = dateTimeFromStrava(
                dataMessage.get('local_timestamp') as double);
          await db.save();
          break;

        default:
          print('Messages of type ' +
              dataMessage.definitionMessage.globalMessageName +
              'are not implemented yet.');
          print(dataMessage.values.map((Value v) => v.fieldName).toList());
        // Use this debugger to implement additional message types!
        // debugger();
      }
    }
    return null;
  }

  Future<void> resetCurrentLap() async {
    currentLap = Lap();
    await currentLap.db.save();
    eventsForCurrentLap = <Event>[];
  }

  Future<BoolResult> delete() async => await db.delete();

  static Future<void> queryStrava({Athlete athlete}) async {
    final Strava strava = Strava(true, secret);
    const String prompt = 'auto';

    await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);

    final int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final int startDate = now - athlete.db.downloadInterval * 86400;

    final List<strava_activity.SummaryActivity> summaryActivities =
        await strava.getLoggedInAthleteActivities(now, startDate);

    await Future.forEach(summaryActivities,
        (strava_activity.SummaryActivity summaryActivity) async {
      final Activity activity = Activity.fromStrava(
        summaryActivity: summaryActivity,
        athlete: athlete,
      );

      final List<DbActivity> existingAlready = await DbActivity()
          .select()
          .stravaId
          .equals(activity.db.stravaId)
          .toList();
      if (existingAlready.isEmpty) {
        await activity.db.save();
      }
    });
  }

  static Future<List<Activity>> all({@required Athlete athlete}) async {
    final List<DbActivity> dbActivityList =
        await athlete.db.getDbActivities().orderByDesc('stravaId').toList();
    final List<Activity> activities = dbActivityList
        .map((DbActivity dbActivity) => Activity.fromDb(dbActivity))
        .toList();
    return activities;
  }

  Future<PowerZoneSchema> get powerZoneSchema async =>
      _powerZoneSchema ??= await PowerZoneSchema.getBy(
        athletesId: db.athletesId,
        date: db.timeCreated,
      );

  Future<HeartRateZoneSchema> get heartRateZoneSchema async =>
      _heartRateZoneSchema ??= await HeartRateZoneSchema.getBy(
        athletesId: db.athletesId,
        date: db.timeCreated,
      );

  Future<PowerZone> get powerZone async {
    if (_powerZone == null) {
      final DbPowerZone dbPowerZone = await DbPowerZone()
          .select()
          .powerZoneSchemataId
          .equals((await powerZoneSchema).id)
          .and
          .lowerLimit
          .lessThanOrEquals(db.avgPower)
          .and
          .upperLimit
          .greaterThanOrEquals(db.avgPower)
          .toSingle();
      _powerZone = PowerZone.fromDb(dbPowerZone);
    }
    return _powerZone;
  }

  Future<HeartRateZone> get heartRateZone async {
    if (_heartRateZone == null) {
      final DbHeartRateZone dbHeartRateZone = await DbHeartRateZone()
          .select()
          .heartRateZoneSchemataId
          .equals((await heartRateZoneSchema).db.id)
          .and
          .lowerLimit
          .lessThanOrEquals(db.avgHeartRate)
          .and
          .upperLimit
          .greaterThanOrEquals(db.avgHeartRate)
          .toSingle();

      _heartRateZone = HeartRateZone.fromDb(dbHeartRateZone);
    }
    return _heartRateZone;
  }

  Future<void> autoTagger({@required Athlete athlete}) async {
    final PowerZone powerZone = await this.powerZone;
    if (powerZone.id != null) {
      final Tag powerTag = await Tag.autoPowerTag(
        athlete: athlete,
        color: powerZone.color,
        sortOrder: powerZone.lowerLimit,
        name: powerZone.name,
      );
      await ActivityTagging.createBy(
        activity: this,
        tag: powerTag,
        system: true,
      );
    }

    final HeartRateZone heartRateZone = await this.heartRateZone;
    if (heartRateZone.db != null) {
      final Tag heartRateTag = await Tag.autoHeartRateTag(
        athlete: athlete,
        color: heartRateZone.db.color,
        sortOrder: heartRateZone.db.lowerLimit,
        name: heartRateZone.db.name,
      );
      await ActivityTagging.createBy(
        activity: this,
        tag: heartRateTag,
        system: true,
      );
    }

    for (final Lap lap in await Lap.all(activity: this)) {
      await lap.autoTagger(athlete: athlete);
    }
  }

  Future<List<BarZone>> powerZoneCounts() async {
    final PowerZoneSchema powerZoneSchema = await this.powerZoneSchema;
    final List<Event> records = await this.records;
    final List<Event> powerRecords =
        records.where((Event record) => record.db.power != null).toList();
    final List<BarZone> powerZoneCounts = await RecordList<Event>(powerRecords)
        .powerZoneCounts(powerZoneSchema: powerZoneSchema);
    return powerZoneCounts;
  }

  Future<List<BarZone>> heartRateZoneCounts() async {
    final HeartRateZoneSchema heartRateZoneSchema =
        await this.heartRateZoneSchema;
    final List<Event> records = await this.records;
    final List<Event> heartRateRecords =
        records.where((Event record) => record.db.heartRate != null).toList();
    final List<BarZone> heartRateZoneCounts =
        await RecordList<Event>(heartRateRecords)
            .heartRateZoneCounts(heartRateZoneSchema: heartRateZoneSchema);
    return heartRateZoneCounts;
  }
}
