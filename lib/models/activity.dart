import 'package:encrateia/models/strava_fit_download.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/strava.dart';
import 'package:encrateia/secrets/secrets.dart';
import 'package:strava_flutter/Models/activity.dart' as StravaActivity;
import 'athlete.dart';
import 'event.dart';
import 'lap.dart';
import 'package:fit_parser/fit_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrateia/utils/date_time_utils.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:encrateia/utils/enums.dart';
import 'dart:io';

class Activity extends ChangeNotifier {
  DbActivity db;
  List<Event> _records;
  List<Lap> _laps;
  double glidingAvgPower;
  double glidingAvgPowerPerHeartRate;
  double glidingAvgSpeedPerHeartRate;
  double glidingAvgPowerRatio;
  double glidingAvgStrideRatio;

  // intermediate data structures used for parsing
  Lap currentLap;
  List<Event> eventsForCurrentLap;

  Activity();
  Activity.fromDb(this.db);

  Activity.fromStrava({
    StravaActivity.SummaryActivity summaryActivity,
    Athlete athlete,
  }) {
    db = DbActivity()
      ..athletesId = athlete.db.id
      ..name = summaryActivity.name
      ..movingTime = summaryActivity.movingTime
      ..type = summaryActivity.type
      ..distance = summaryActivity.distance.toInt()
      ..stravaId = summaryActivity.id
      // ..startTime = summaryActivity.startDate
      ..movingTime = summaryActivity.movingTime;
  }

  Activity.fromLocalDirectory({Athlete athlete}) {
    db = DbActivity()
      ..athletesId = athlete.db.id
      ..name = "t.b.d.";
  }

  String toString() => '$db.name $db.startTime';
  Duration movingDuration() => Duration(seconds: db.movingTime ?? 0);

  get({ActivityAttr quantity}) {
    switch (quantity) {
      case ActivityAttr.avgPower:
        return db.avgPower;
      case ActivityAttr.avgPowerPerHeartRate:
        return (db.avgPower / db.avgHeartRate);
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

  setGliding({ActivityAttr quantity, double value}) {
    switch (quantity) {
      case ActivityAttr.avgPower:
        glidingAvgPower = value;
        break;
      case ActivityAttr.avgPowerPerHeartRate:
        glidingAvgPowerPerHeartRate = value;
        break;
      case ActivityAttr.avgSpeedPerHeartRate:
        glidingAvgSpeedPerHeartRate = value;
        break;
      case ActivityAttr.avgPowerRatio:
        glidingAvgPowerRatio = value;
        break;
      case ActivityAttr.avgStrideRatio:
        glidingAvgStrideRatio = value;
        break;
    }
  }

  download({@required Athlete athlete}) async {
    await StravaFitDownload.byId(id: db.stravaId.toString(), athlete: athlete);
    setState("downloaded");
  }

  Future<bool> copyFromLocalDir() async {
    var directories = await getExternalStorageDirectories();
    var localDir = directories[0];
    var appDocDir = await getApplicationDocumentsDirectory();
    var pseudoStravaId = DateTime.now().millisecondsSinceEpoch;

    localDir
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) async {
      var isFile = await FileSystemEntity.isFile(entity.path);
      if (isFile == true && entity.path.endsWith('.fit')) {
        var sourceFile = File(entity.path);
        await sourceFile
            .copy(appDocDir.path + "/" + pseudoStravaId.toString() + ".fit");
        sourceFile.delete();
        db.stravaId = pseudoStravaId;
        setState("downloaded");
        return true;
      }
      return false; // No fit-file
    });
    return false; // Empty directory
  }

  setState(String state) async {
    db.state = state;
    await db.save();
    notifyListeners();
  }

  distanceString() {
    return db.totalDistance == null
        ? "- - -"
        : (db.totalDistance / 1000).toStringAsFixed(2) + " km";
  }

  heartRateString() {
    return db.avgHeartRate == null
        ? "- - -"
        : db.avgHeartRate.toString() + " bpm";
  }

  averagePowerString() {
    return db.avgPower == null
        ? "- - -"
        : db.avgPower.toStringAsFixed(1) + " W";
  }

  timeString() {
    return db.timeCreated == null
        ? "- - -"
        : DateFormat("H:mm").format(db.timeCreated);
  }

  dateString() {
    return db.timeCreated == null
        ? "- - -"
        : DateFormat("d MMM yy").format(db.timeCreated);
  }

  shortDateString() {
    return db.timeCreated == null
        ? "- - -"
        : DateFormat("d.M.").format(db.timeCreated);
  }

  paceString() => db.avgSpeed.toPace() + "/km";

  Future<List<Event>> get records async {
    if (_records == null) {
      _records = await Event.recordsByActivity(activity: this);
    }
    return _records;
  }

  Future<List<Lap>> get laps async {
    if (_laps == null) {
      _laps = await Lap.by(activity: this);
    }
    return _laps;
  }

  recalculateAverages() async {
    var records = await this.records;
    db.avgPower = Lap.calculateAveragePower(records: records);
    db.sdevPower = Lap.calculateSdevPower(records: records);
    db.minPower = Lap.calculateMinPower(records: records);
    db.maxPower = Lap.calculateMaxPower(records: records);
    db.avgSpeed = Lap.calculateAverageSpeed(records: records);
    db.avgGroundTime = Lap.calculateAverageGroundTime(records: records);
    db.sdevGroundTime = Lap.calculateSdevGroundTime(records: records);
    db.avgVerticalOscillation =
        Lap.calculateAverageVerticalOscillation(records: records);
    db.sdevVerticalOscillation =
        Lap.calculateSdevVerticalOscillation(records: records);
    db.avgStrydCadence = Lap.calculateAverageStrydCadence(records: records);
    db.sdevStrydCadence = Lap.calculateSdevStrydCadence(records: records);
    db.avgLegSpringStiffness =
        Lap.calculateAverageLegSpringStiffness(records: records);
    db.sdevLegSpringStiffness =
        Lap.calculateSdevLegSpringStiffness(records: records);
    db.avgFormPower = Lap.calculateAverageFormPower(records: records);
    db.sdevFormPower = Lap.calculateSdevFormPower(records: records);
    db.avgPowerRatio = Lap.calculateAveragePowerRatio(records: records);
    db.sdevPowerRatio = Lap.calculateSdevPowerRatio(records: records);
    db.avgStrideRatio = Lap.calculateAverageStrideRatio(records: records);
    db.sdevStrideRatio = Lap.calculateSdevStrideRatio(records: records);

    var laps = await this.laps;
    for (Lap lap in laps) {
      var records = await lap.records;
      lap.db.avgPower = Lap.calculateAveragePower(records: records);
      await lap.db.save();
    }
    await db.save();
    return true;
  }

  Stream<int> parse({@required Athlete athlete}) async* {
    int counter = 0;
    int percentage;

    var appDocDir = await getApplicationDocumentsDirectory();
    var fitFile = FitFile(path: appDocDir.path + '/${db.stravaId}.fit').parse();
    print("Parsing .fit-File for »${db.name}« done.");

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

    int numberOfMessages = fitFile.dataMessages.length;
    await resetCurrentLap();

    for (DataMessage dataMessage in fitFile.dataMessages) {
      counter++;
      percentage = await handleDataMessage(dataMessage: dataMessage);

      if (counter % 100 == 0) {
        percentage = (counter / numberOfMessages * 100).round();
        yield percentage;
      }
    }

    db.state = "persisted";
    await recalculateAverages();
    await db.save();
    notifyListeners();
    print("Activity data for »${db.name}« stored in database.");
    yield 100;
  }

  handleDataMessage({DataMessage dataMessage}) async {
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
          break;
        default:
          print("Message number "
              "${dataMessage.definitionMessage.globalMessageNumber} "
              "unknown.");
          debugger();
      }
    } else {
      switch (dataMessage.definitionMessage.globalMessageName) {
        case 'developer_data_id':
        case "device_info":
        case "device_settings":
        case "field_description":
        case "file_creator":
        case "user_profile":
        case "zones_target":
          break; // we are currently not storing these kinds of messages

        case "file_id":
          db
            ..serialNumber = dataMessage.get('serial_number')?.round()
            ..timeCreated = dateTimeFromStrava(dataMessage.get('time_created'));
          await db.save();
          break;

        case "sport":
          db
            ..sportName = dataMessage.get('name')
            ..sport = dataMessage.get('sport')
            ..subSport = dataMessage.get('sub_sport');
          await db.save();
          break;

        case "event":
          var event = Event(
            dataMessage: dataMessage,
            activity: this,
          );
          eventsForCurrentLap.add(event);
          break;

        case "record":
          var event = Event.fromRecord(
            dataMessage: dataMessage,
            activity: this,
            lapsId: currentLap.db.id,
          );
          eventsForCurrentLap.add(event);
          break;

        case "lap":
          var event = Event.fromLap(
            dataMessage: dataMessage,
            activity: this,
            lapsId: currentLap.db.id,
          );
          eventsForCurrentLap.add(event);

          var lap = Lap.fromLap(
            dataMessage: dataMessage,
            activity: this,
            lap: currentLap,
          );
          await lap.db.save();
          await DbEvent()
              .upsertAll(eventsForCurrentLap.map((event) => event.db).toList());

          await resetCurrentLap();
          break;

        case "segment_lap":
          break;

        case "session":
          db
            ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
            ..startTime = dateTimeFromStrava(dataMessage.get('start_time'))
            ..startPositionLat = dataMessage.get('start_position_lat')
            ..startPositionLong = dataMessage.get('start_position_long')
            ..totalElapsedTime = dataMessage.get('total_elapsed_time')?.round()
            ..totalTimerTime = dataMessage.get('total_timer_time')?.round()
            ..totalDistance = dataMessage.get('total_distance')?.round()
            ..totalStrides = dataMessage.get('total_strides')?.round()
            ..necLat = dataMessage.get('nec_lat')
            ..necLong = dataMessage.get('nec_long')
            ..swcLat = dataMessage.get('swc_lat')
            ..swcLong = dataMessage.get('swc_long')
            ..totalCalories = dataMessage.get('total_calories')?.round()
            ..avgSpeed = dataMessage.get('avg_speed')
            ..maxSpeed = dataMessage.get('max_speed')
            ..totalAscent = dataMessage.get('total_ascent')?.round()
            ..totalDescent = dataMessage.get('total_descent')?.round()
            ..maxRunningCadence =
                dataMessage.get('max_running_cadence')?.round()
            ..firstLapIndex = dataMessage.get('first_lap_index')?.round()
            ..numLaps = dataMessage.get('num_laps')?.round()
            ..event = dataMessage.get('event')?.toString()
            ..eventType = dataMessage.get('event_type')
            ..eventGroup = dataMessage.get('event_group')?.round()
            ..trigger = dataMessage.get('trigger')
            ..avgVerticalOscillation =
                dataMessage.get('avg_vertical_oscillation')
            ..avgStanceTimePercent = dataMessage.get('avg_stance_time_percent')
            ..avgStanceTime = dataMessage.get('avg_stance_time')
            ..sport = dataMessage.get('sport')
            ..subSport = dataMessage.get('sub_sport')
            ..avgHeartRate = dataMessage.get('avg_heart_rate')?.round()
            ..maxHeartRate = dataMessage.get('max_heart_rate')?.round()
            ..avgRunningCadence = dataMessage.get('avg_running_cadence')
            ..totalTrainingEffect =
                dataMessage.get('total_training_effect')?.round()
            ..avgTemperature = dataMessage.get('avg_temperature')?.round()
            ..maxTemperature = dataMessage.get('max_temperature')?.round()
            ..avgFractionalCadence = dataMessage.get('avg_fractional_cadence')
            ..maxFractionalCadence = dataMessage.get('max_fractional_cadence')
            ..totalFractionalCycles =
                dataMessage.get('total_fractional_cycles');
          await db.save();
          break;

        case "activity":
          db
            ..numSessions = dataMessage.get('num_sessions')?.round()
            ..localTimestamp =
                dateTimeFromStrava(dataMessage.get('local_timestamp'));
          await db.save();
          break;

        default:
          print("Messages of type "
              "${dataMessage.definitionMessage.globalMessageName} "
              "are not implemented yet.");
          print(dataMessage.values.map((v) => v.fieldName).toList());
        // Use this debugger to implement additional message types!
        // debugger();
      }
    }
  }

  resetCurrentLap() async {
    currentLap = Lap();
    await currentLap.db.save();
    eventsForCurrentLap = [];
  }

  delete() async {
    await this.db.delete();
  }

  static queryStrava({Athlete athlete}) async {
    var strava = Strava(true, secret);
    final prompt = 'auto';

    await strava.oauth(
        clientId,
        'activity:write,activity:read_all,profile:read_all,profile:write',
        secret,
        prompt);

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final startDate = now - athlete.db.downloadInterval * 86400;

    List<StravaActivity.SummaryActivity> summaryActivities =
        await strava.getLoggedInAthleteActivities(now, startDate);

    await Future.forEach(summaryActivities,
        (StravaActivity.SummaryActivity summaryActivity) async {
      var activity = Activity.fromStrava(
        summaryActivity: summaryActivity,
        athlete: athlete,
      );

      var existingAlready = await DbActivity()
          .select()
          .stravaId
          .equals(activity.db.stravaId)
          .toList();
      if (existingAlready.length == 0) {
        await activity.db.save();
      }
    });
  }

  static importFromLocalDirectory({Athlete athlete}) async {
    var activity = Activity.fromLocalDirectory(athlete: athlete);
    await activity.copyFromLocalDir();
  }

  static Future<List<Activity>> all({@required Athlete athlete}) async {
    var dbActivityList =
        await athlete.db.getDbActivities().orderByDesc('stravaId').toList();
    var activities = dbActivityList
        .map((dbActivity) => Activity.fromDb(dbActivity))
        .toList();
    return activities;
  }
}
