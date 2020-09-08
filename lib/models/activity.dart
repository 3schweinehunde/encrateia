import 'dart:developer';
import 'dart:io';

import 'package:encrateia/model/model.dart'
    show DbActivity, DbEvent, DbHeartRateZone, DbInterval, DbLap, DbPowerZone;
import 'package:encrateia/secrets/secrets.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:fit_parser/fit_parser.dart';
// ignore: implementation_imports
import 'package:fit_parser/src/value.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:strava_flutter/Models/activity.dart' as strava_activity;
import 'package:strava_flutter/strava.dart';

import 'activity_tagging.dart';
import 'athlete.dart';
import 'bar_zone.dart';
import 'event.dart';
import 'heart_rate_zone.dart';
import 'heart_rate_zone_schema.dart';
import 'interval.dart' as encrateia;
import 'lap.dart';
import 'power_zone.dart';
import 'power_zone_schema.dart';
import 'record_list.dart';
import 'strava_fit_download.dart';
import 'tag.dart';
import 'weight.dart';

class Activity {
  Activity();
  Activity._fromDb(this._db);

  Activity.fromStrava({
    @required strava_activity.SummaryActivity summaryActivity,
    @required Athlete athlete,
  }) {
    _db = DbActivity()
      ..athletesId = athlete.id
      ..name = summaryActivity.name
      ..type = summaryActivity.type
      ..distance = summaryActivity.distance.toInt()
      ..stravaId = summaryActivity.id;
  }

  Activity.fromLocalDirectory({@required Athlete athlete}) {
    _db = DbActivity()
      ..athletesId = athlete.id
      ..stravaId = DateTime.now().millisecondsSinceEpoch
      ..name = 'new activity';
  }

  Activity.manual({@required Athlete athlete}) {
    _db = DbActivity()
      ..athletesId = athlete.id
      ..stravaId = DateTime.now().millisecondsSinceEpoch
      ..movingTime = 0
      ..totalAscent = 0
      ..totalDescent = 0
      ..totalDistance = 0
      ..avgHeartRate = 0
      ..avgPower = 0
      ..timeCreated = DateTime.now();
  }

  DbActivity _db;
  List<Event> cachedRecords = <Event>[];
  List<Lap> cachedLaps = <Lap>[];
  List<encrateia.Interval> cachedIntervals = <encrateia.Interval>[];
  List<Tag> cachedTags = <Tag>[];
  double glidingMeasureAttribute;
  double cachedWeight;
  double cachedEcor;
  PowerZoneSchema _powerZoneSchema;
  PowerZone _powerZone;
  HeartRateZone _heartRateZone;
  HeartRateZoneSchema _heartRateZoneSchema;

  // Getter
  int get id => _db?.id;

  DateTime get startTime => _db.startTime;
  DateTime get timeCreated => _db.timeCreated;
  DateTime get timeStamp => _db.timeStamp;

  String get event => _db.event;
  String get eventType => _db.eventType;
  String get name => _db.name;
  String get sport => _db.sport;
  String get state => _db.state;
  String get subSport => _db.subSport;
  String get trigger => _db.trigger;
  String get type => _db.type;

  bool get excluded => _db.excluded;
  bool get manual => _db.manual;
  bool get nonParsable => _db.nonParsable;

  double get avgFormPower => _db.avgFormPower;
  double get avgFractionalCadence => _db.avgFractionalCadence;
  double get avgGroundTime => _db.avgGroundTime;
  double get avgLegSpringStiffness => _db.avgLegSpringStiffness;
  double get avgPower => _db.avgPower;
  double get avgPowerRatio => _db.avgPowerRatio;
  double get avgRunningCadence => _db.avgRunningCadence;
  double get avgSpeed => _db.avgSpeed;
  double get avgSpeedByDistance => _db.avgSpeedByDistance;
  double get avgSpeedByMeasurements => _db.avgSpeedByMeasurements;
  double get avgSpeedBySpeed => _db.avgSpeedBySpeed;
  double get avgStanceTime => _db.avgStanceTime;
  double get avgStanceTimePercent => _db.avgStanceTimePercent;
  double get avgStrideRatio => _db.avgStrideRatio;
  double get avgStrydCadence => _db.avgStrydCadence;
  double get avgVerticalOscillation => _db.avgVerticalOscillation;
  double get cp => _db.cp;
  double get ftp => _db.ftp;
  double get maxFractionalCadence => _db.maxFractionalCadence;
  double get maxSpeed => _db.maxSpeed;
  double get minSpeed => _db.minSpeed;
  double get necLat => _db.necLat;
  double get necLong => _db.necLong;
  double get sdevFormPower => _db.sdevFormPower;
  double get sdevGroundTime => _db.sdevGroundTime;
  double get sdevHeartRate => _db.sdevHeartRate;
  double get sdevLegSpringStiffness => _db.sdevLegSpringStiffness;
  double get sdevPace => _db.sdevPace;
  double get sdevPower => _db.sdevPower;
  double get sdevPowerRatio => _db.sdevPowerRatio;
  double get sdevSpeed => _db.sdevSpeed;
  double get sdevStrideRatio => _db.sdevStrideRatio;
  double get sdevStrydCadence => _db.sdevStrydCadence;
  double get sdevVerticalOscillation => _db.sdevVerticalOscillation;
  double get startPositionLat => _db.startPositionLat;
  double get startPositionLong => _db.startPositionLong;
  double get swcLat => _db.swcLat;
  double get swcLong => _db.swcLong;
  double get totalFractionalCycles => _db.totalFractionalCycles;

  int get athletesId => _db.athletesId;
  int get avgHeartRate => _db.avgHeartRate;
  int get avgTemperature => _db.avgTemperature;
  int get distance => _db.distance;
  int get maxHeartRate => _db.maxHeartRate;
  int get maxPower => _db.maxPower;
  int get maxRunningCadence => _db.maxRunningCadence;
  int get maxTemperature => _db.maxTemperature;
  int get minHeartRate => _db.minHeartRate;
  int get minPower => _db.minPower;
  int get movingTime => _db.movingTime;
  int get numLaps => _db.numLaps;
  int get numSessions => _db.numSessions;
  int get serialNumber => _db.serialNumber;
  int get stravaId => _db.stravaId;
  int get totalAscent => _db.totalAscent;
  int get totalCalories => _db.totalCalories;
  int get totalDescent => _db.totalDescent;
  int get totalDistance => _db.totalDistance;
  int get totalElapsedTime => _db.totalElapsedTime;
  int get totalStrides => _db.totalStrides;
  int get totalTimerTime => _db.totalTimerTime;
  int get totalTrainingEffect => _db.totalTrainingEffect;

  // calculated from other attributes:
  double get avgPace {
    if (avgSpeed != null && avgSpeed != 0)
      return 50 / 3 / avgSpeed;
    else
      return null;
  }

  double get avgSpeedPerHeartRate {
    if (avgSpeed != null && heartRateAvailable)
      return 60 * avgSpeed / avgHeartRate;
    else
      return null;
  }

  double get avgPowerPerHeartRate {
    if (powerAvailable && heartRateAvailable)
      return avgPower / avgHeartRate;
    else
      return null;
  }

  int get elevationDifference =>
      ascentAvailable ? totalAscent - totalDescent : null;

  double get avgDoubleStrydCadence =>
      cadenceAvailable ? avgStrydCadence * 2 : null;

  // easier check for data availability
  bool get powerAvailable => !<num>[null, -1].contains(avgPower);
  bool get powerRatioAvailable => !<num>[null, -1].contains(avgPowerRatio);
  bool get heartRateAvailable => !<num>[null, -1].contains(avgHeartRate);
  bool get ascentAvailable => totalAscent != null && totalDescent != null;
  bool get cadenceAvailable => !<num>[null, -1].contains(avgStrydCadence);
  bool get speedAvailable => !<num>[null, 0, -1].contains(avgSpeedByDistance);
  bool get paceAvailable => !<num>[null, -1].contains(avgPace);
  bool get ecorAvailable => powerAvailable && speedAvailable;
  bool get groundTimeAvailable => !<num>[null, -1].contains(avgGroundTime);
  bool get formPowerAvailable => !<num>[null, -1].contains(avgFormPower);
  bool get verticalOscillationAvailable =>
      !<num>[null, -1].contains(avgVerticalOscillation);
  bool get strideRatioAvailable => !<num>[null, -1].contains(avgStrideRatio);
  bool get strideCadenceAvailable =>
      !<num>[null, -1].contains(avgDoubleStrydCadence);
  bool get legSpringStiffnessAvailable =>
      !<num>[null, -1].contains(avgLegSpringStiffness);

  // Setter

  set excluded(bool value) => _db.excluded = value;
  set ftp(double value) => _db.ftp = value;
  set manual(bool value) => _db.manual = value;
  set maxHeartRate(int value) => _db.maxHeartRate = value;
  set name(String value) => _db.name = value;
  set nonParsable(bool value) => _db.nonParsable = value;
  set state(String value) => _db.state = value;
  set timeStamp(DateTime value) => _db.timeStamp = value;
  set timeCreated(DateTime value) => _db.timeCreated = value;
  set totalDistance(int value) => _db.totalDistance = value;
  set totalAscent(int value) => _db.totalAscent = value;
  set totalDescent(int value) => _db.totalDescent = value;
  set avgHeartRate(int value) => _db.avgHeartRate = value;
  set avgPower(double value) => _db.avgPower = value;
  set sport(String value) => _db.sport = value;
  set subSport(String value) => _db.subSport = value;
  set movingTime(int value) => _db.movingTime = value;

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  // intermediate data structures used for parsing
  Lap currentLap;
  List<Event> eventsForCurrentLap;

  @override
  String toString() => '< Activity | $name | $startTime >';

  dynamic getAttribute(ActivityAttr activityAttr) {
    switch (activityAttr) {
      case ActivityAttr.avgPower:
        return avgPower;
      case ActivityAttr.ecor:
        return cachedEcor;
      case ActivityAttr.avgPowerPerHeartRate:
        return avgPowerPerHeartRate;
      case ActivityAttr.avgSpeedPerHeartRate:
        return avgSpeedPerHeartRate;
      case ActivityAttr.avgPowerRatio:
        return avgPowerRatio;
      case ActivityAttr.avgStrideRatio:
        return avgStrideRatio;
      case ActivityAttr.avgPace:
        return avgPace;
      case ActivityAttr.avgHeartRate:
        return avgHeartRate.toDouble();
      case ActivityAttr.avgDoubleStrydCadence:
        return avgDoubleStrydCadence;
      case ActivityAttr.ftp:
        return ftp;
    }
  }

  Future<void> download({@required Athlete athlete}) async {
    await StravaFitDownload.byId(id: stravaId.toString(), athlete: athlete);
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
        if (isFile == true && entity.path.toLowerCase().endsWith('.fit')) {
          final File sourceFile = File(entity.path);
          await sourceFile.copy(
              appDocDir.path + '/' + activity.stravaId.toString() + '.fit');
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
              appDocDir.path + '/' + activity.stravaId.toString() + '.fit');
          await activity.setState('downloaded');
        }
      }
    }
  }

  Future<void> setState(String state) async {
    _db.state = state;
    await save();
  }

  Future<List<Event>> get records async {
    if (cachedRecords.isEmpty) {
      final List<DbEvent> dbEventList = await _db.getDbEvents().toList();
      final Iterable<DbEvent> dbRecordList =
          dbEventList.where((DbEvent dbEvent) => dbEvent.event == 'record');
      cachedRecords = dbRecordList.map(Event.exDb).toList();
    }
    return cachedRecords;
  }

  Future<List<Tag>> get tags async {
    if (cachedTags.isEmpty) {
      cachedTags = await Tag.allByActivity(activity: this);
    }
    return cachedTags;
  }

  Future<double> get weight async {
    if (cachedWeight == null) {
      final Weight weight = await Weight.getBy(
        athletesId: athletesId,
        date: timeCreated,
      );
      cachedWeight = weight.value;
    }
    return cachedWeight;
  }

  Future<double> get ecor async {
    if (cachedEcor == null) {
      final double weightValue = await weight;
      cachedEcor = (powerAvailable && speedAvailable && weightValue != null)
          ? avgPower / avgSpeed / weightValue
          : -1;
    }
    return cachedEcor;
  }

  Future<bool> setAverages() async {
    final RecordList<Event> recordList = RecordList<Event>(await records);
    _db
      ..avgPower = recordList.avgPower()
      ..sdevPower = recordList.sdevPower()
      ..minPower = recordList.minPower()
      ..maxPower = recordList.maxPower()
      ..avgHeartRate = recordList.avgHeartRate()
      ..sdevHeartRate = recordList.sdevHeartRate()
      ..minHeartRate = recordList.minHeartRate()
      ..maxHeartRate = recordList.maxHeartRate()
      ..avgSpeedByMeasurements = recordList.avgSpeedByMeasurements()
      ..avgSpeedBySpeed = recordList.avgSpeedBySpeed()
      ..avgSpeedByDistance = recordList.avgSpeedByDistance()
      ..sdevSpeed = recordList.sdevSpeed()
      ..sdevPace = recordList.sdevPace()
      ..minSpeed = recordList.minSpeed()
      ..maxSpeed = recordList.maxSpeed()
      ..avgGroundTime = recordList.avgGroundTime()
      ..sdevGroundTime = recordList.sdevGroundTime()
      ..avgStrydCadence = recordList.avgStrydCadence()
      ..sdevStrydCadence = recordList.sdevStrydCadence()
      ..avgLegSpringStiffness = recordList.avgLegSpringStiffness()
      ..sdevLegSpringStiffness = recordList.sdevLegSpringStiffness()
      ..avgVerticalOscillation = recordList.avgVerticalOscillation()
      ..sdevVerticalOscillation = recordList.sdevVerticalOscillation()
      ..avgFormPower = recordList.avgFormPower()
      ..sdevFormPower = recordList.sdevFormPower()
      ..avgPowerRatio = recordList.avgPowerRatio()
      ..sdevPowerRatio = recordList.sdevPowerRatio()
      ..avgStrideRatio = recordList.avgStrideRatio()
      ..sdevStrideRatio = recordList.sdevStrideRatio()
      ..movingTime = recordList.movingTime();

    final List<Lap> laps = await this.laps;
    for (final Lap lap in laps) {
      await lap.setAverages();
    }
    await save();
    return true;
  }

  Stream<int> parse({@required Athlete athlete}) async* {
    int counter = 0;
    int percentage;

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final FitFile fitFile =
        FitFile(path: appDocDir.path + '/$stravaId.fit').parse();
    print('Parsing .fit-File for »$name« done.');

    // delete left overs from prior runs:
    await _db.getDbEvents().delete();
    await _db.getDbLaps().delete();
    _db
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
    await save();

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

    state = 'persisted';
    yield -1;
    await setAverages();
    yield -2;
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
          _db
            ..serialNumber =
                (dataMessage.get('serial_number') as double)?.round()
            ..timeCreated =
                dateTimeFromStrava(dataMessage.get('time_created') as double);
          await save();
          break;

        case 'sport':
          _db
            ..sportName = dataMessage.get('name') as String
            ..sport = dataMessage.get('sport') as String
            ..subSport = dataMessage.get('sub_sport') as String;
          await save();
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
            lapsId: currentLap.id,
          );
          eventsForCurrentLap.add(event);
          break;

        case 'lap':
          final Event event = Event.fromLap(
            dataMessage: dataMessage,
            activity: this,
            lapsId: currentLap.id,
          );
          eventsForCurrentLap.add(event);

          final Lap lap = Lap.fromLap(
            dataMessage: dataMessage,
            activity: this,
            lap: currentLap,
          );
          await lap.save();
          await Event.upsertAll(eventsForCurrentLap);

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

          if (name == 'new activity')
            name =
                'Activity on ' + DateFormat.yMMMMd('en_US').format(startTime);
          _db
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
            ..distance = (distance ??
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
            ..type = type ?? dataMessage.get('event_type') as String
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
          await save();
          break;

        case 'activity':
          _db
            ..numSessions = (dataMessage.get('num_sessions') as double)?.round()
            ..localTimestamp = dateTimeFromStrava(
                dataMessage.get('local_timestamp') as double);
          await save();
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
    await currentLap.save();
    eventsForCurrentLap = <Event>[];
  }

  static Future<void> queryStrava({Athlete athlete}) async {
    final Strava strava = Strava(true, secret);
    const String prompt = 'auto';

    await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);

    final int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final int startDate = now - athlete.downloadInterval * 86400;

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
          .equals(activity.stravaId)
          .toList();
      if (existingAlready.isEmpty) {
        await activity.save();
      }
    });
  }

  Future<PowerZoneSchema> get powerZoneSchema async =>
      _powerZoneSchema ??= await PowerZoneSchema.getBy(
        athletesId: athletesId,
        date: timeCreated,
      );

  Future<HeartRateZoneSchema> get heartRateZoneSchema async =>
      _heartRateZoneSchema ??= await HeartRateZoneSchema.getBy(
        athletesId: athletesId,
        date: timeCreated,
      );

  Future<PowerZone> get powerZone async {
    if (_powerZone == null) {
      final DbPowerZone dbPowerZone = await DbPowerZone()
          .select()
          .powerZoneSchemataId
          .equals((await powerZoneSchema).id)
          .and
          .lowerLimit
          .lessThanOrEquals(avgPower)
          .and
          .upperLimit
          .greaterThanOrEquals(avgPower)
          .toSingle();
      _powerZone = PowerZone.exDb(dbPowerZone);
    }
    return _powerZone;
  }

  Future<HeartRateZone> get heartRateZone async {
    if (_heartRateZone == null) {
      final DbHeartRateZone dbHeartRateZone = await DbHeartRateZone()
          .select()
          .heartRateZoneSchemataId
          .equals((await heartRateZoneSchema).id)
          .and
          .lowerLimit
          .lessThanOrEquals(avgHeartRate)
          .and
          .upperLimit
          .greaterThanOrEquals(avgHeartRate)
          .toSingle();

      _heartRateZone = HeartRateZone.exDb(dbHeartRateZone);
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
    if (heartRateZone.id != null) {
      final Tag heartRateTag = await Tag.autoHeartRateTag(
        athlete: athlete,
        color: heartRateZone.color,
        sortOrder: heartRateZone.lowerLimit,
        name: heartRateZone.name,
      );
      await ActivityTagging.createBy(
        activity: this,
        tag: heartRateTag,
        system: true,
      );
    }

    for (final Lap lap in await laps) {
      await lap.autoTagger(athlete: athlete);
    }
  }

  Future<List<BarZone>> powerZoneCounts() async {
    final PowerZoneSchema powerZoneSchema = await this.powerZoneSchema;
    final List<Event> records = await this.records;
    final List<Event> powerRecords =
        records.where((Event record) => record.power != null).toList();
    final List<BarZone> powerZoneCounts = await RecordList<Event>(powerRecords)
        .powerZoneCounts(powerZoneSchema: powerZoneSchema);
    return powerZoneCounts;
  }

  Future<List<BarZone>> heartRateZoneCounts() async {
    final HeartRateZoneSchema heartRateZoneSchema =
        await this.heartRateZoneSchema;
    final List<Event> records = await this.records;
    final List<Event> heartRateRecords =
        records.where((Event record) => record.heartRate != null).toList();
    final List<BarZone> heartRateZoneCounts =
        await RecordList<Event>(heartRateRecords)
            .heartRateZoneCounts(heartRateZoneSchema: heartRateZoneSchema);
    return heartRateZoneCounts;
  }

  Future<List<Lap>> get laps async {
    if (cachedLaps.isEmpty) {
      int counter = 1;

      final List<DbLap> dbLapList = await _db.getDbLaps().toList();
      cachedLaps = dbLapList.map(Lap.exDb).toList();

      for (final Lap lap in cachedLaps) {
        lap
          ..activity = this
          ..index = counter;
        counter = counter + 1;
      }
    }
    return cachedLaps;
  }

  Future<List<encrateia.Interval>> get intervals async {
    int counter = 1;

    final List<DbInterval> dbIntervalList = await _db.getDbIntervals().toList();
    cachedIntervals = dbIntervalList.map(encrateia.Interval.exDb).toList();

    for (final encrateia.Interval interval in cachedIntervals) {
      interval
        ..activity = this
        ..index = counter;
      counter = counter + 1;
    }
    return cachedIntervals;
  }

  Future<BoolResult> deleteEvents() async => await _db.getDbEvents().delete();
  Future<BoolResult> deleteLaps() async => await _db.getDbLaps().delete();

  static Activity exDb(DbActivity db) => Activity._fromDb(db);
}
