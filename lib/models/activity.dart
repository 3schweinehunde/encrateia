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

class Activity extends ChangeNotifier {
  DbActivity db;
  List<Event> _records;
  List<Lap> _laps;

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
      ..startTime = summaryActivity.startDate
      ..movingTime = summaryActivity.movingTime;
  }

  String toString() => '$db.name $db.startTime';
  Duration movingDuration() => Duration(seconds: db.movingTime ?? 0);

  download({@required Athlete athlete}) async {
    await StravaFitDownload.byId(id: db.stravaId.toString(), athlete: athlete);
    setState("downloaded");
  }

  setState(String state) async {
    db.state = state;
    await db.save();
    notifyListeners();
  }

  distanceString() {
    if (db.totalDistance != null) {
      return (db.totalDistance / 1000).toStringAsFixed(2) + " km";
    } else
      return "";
  }

  heartRateString() {
    if (db.avgHeartRate != null) {
      return db.avgHeartRate.toString() + " bpm";
    } else
      return "";
  }

  timeString() => DateFormat("H:mm").format(db.timeCreated);

  dateString() => DateFormat("d MMM yy").format(db.timeCreated);
  shortDateString() => DateFormat("d.M.").format(db.timeCreated);

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

  Future<double> get avgPower async {
    if (db.avgPower == null) {
      List<Event> records = await this.records;
      db.avgPower = Lap.calculateAveragePower(records: records);
      await db.save();
      notifyListeners();
    }
    return db.avgPower;
  }

  Future<double> get sdevPower async {
    if (db.sdevPower == null) {
      List<Event> records = await this.records;
      db.sdevPower = Lap.calculateSdevPower(records: records);
      await db.save();
      notifyListeners();
    }
    return db.sdevPower;
  }

  Future<int> get minPower async {
    if (db.minPower == null) {
      List<Event> records = await this.records;
      db.minPower = Lap.calculateMinPower(records: records);
      await db.save();
      notifyListeners();
    }
    return db.minPower;
  }

  Future<int> get maxPower async {
    if (db.maxPower == null) {
      List<Event> records = await this.records;
      db.maxPower = Lap.calculateMaxPower(records: records);
      await db.save();
      notifyListeners();
    }
    return db.maxPower;
  }

  Future<double> get avgSpeed async {
    if (db.avgSpeed == null || db.avgSpeed == 0) {
      List<Event> records = await this.records;
      db.avgSpeed = Lap.calculateAverageSpeed(records: records);
      await db.save();
      notifyListeners();
    }
    return db.avgGroundTime;
  }


  Future<double> get avgGroundTime async {
    if (db.avgGroundTime == null) {
      List<Event> records = await this.records;
      db.avgGroundTime = Lap.calculateAverageGroundTime(records: records);
      await db.save();
      notifyListeners();
    }
    return db.avgGroundTime;
  }

  Future<double> get sdevGroundTime async {
    if (db.sdevGroundTime == null) {
      List<Event> records = await this.records;
      db.sdevGroundTime = Lap.calculateSdevGroundTime(records: records);
      await db.save();
      notifyListeners();
    }
    return db.sdevGroundTime;
  }

  Future<double> get avgVerticalOscillation async {
    if (db.avgVerticalOscillation == null ||
        db.avgVerticalOscillation == 6553.5) {
      List<Event> records = await this.records;
      db.avgVerticalOscillation =
          Lap.calculateAverageVerticalOscillation(records: records);
      await db.save();
      notifyListeners();
    }
    return db.avgVerticalOscillation;
  }

  Future<double> get sdevVerticalOscillation async {
    if (db.sdevVerticalOscillation == null) {
      List<Event> records = await this.records;
      db.sdevVerticalOscillation =
          Lap.calculateSdevVerticalOscillation(records: records);
      await db.save();
      notifyListeners();
    }
    return db.sdevVerticalOscillation;
  }

  Future<double> get avgStrydCadence async {
    if (db.avgStrydCadence == null) {
      List<Event> records = await this.records;
      db.avgStrydCadence = Lap.calculateAverageStrydCadence(records: records);
      await db.save();
      notifyListeners();
    }
    return db.avgStrydCadence;
  }

  Future<double> get sdevStrydCadence async {
    if (db.sdevStrydCadence == null) {
      List<Event> records = await this.records;
      db.sdevStrydCadence = Lap.calculateSdevStrydCadence(records: records);
      await db.save();
      notifyListeners();
    }
    return db.sdevStrydCadence;
  }

  Future<double> get avgLegSpringStiffness async {
    if (db.avgLegSpringStiffness == null) {
      List<Event> records = await this.records;
      db.avgLegSpringStiffness =
          Lap.calculateAverageLegSpringStiffness(records: records);
      await db.save();
      notifyListeners();
    }
    return db.avgLegSpringStiffness;
  }

  Future<double> get sdevLegSpringStiffness async {
    if (db.sdevLegSpringStiffness == null) {
      List<Event> records = await this.records;
      db.sdevLegSpringStiffness =
          Lap.calculateSdevLegSpringStiffness(records: records);
      await db.save();
      notifyListeners();
    }
    return db.sdevLegSpringStiffness;
  }

  Future<double> get avgFormPower async {
    if (db.avgFormPower == null) {
      List<Event> records = await this.records;
      db.avgFormPower = Lap.calculateAverageFormPower(records: records);
      await db.save();
      notifyListeners();
    }
    return db.avgFormPower;
  }

  Future<double> get sdevFormPower async {
    if (db.sdevFormPower == null) {
      List<Event> records = await this.records;
      db.sdevFormPower = Lap.calculateSdevFormPower(records: records);
      await db.save();
      notifyListeners();
    }
    return db.sdevFormPower;
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
    await db.save();
    notifyListeners();
    print("Activity data for »${db.name}« stored in database.");
    yield 100;
  }

  handleDataMessage({
    DataMessage dataMessage,
  }) async {
    if (dataMessage.definitionMessage.globalMessageName == null) {
      switch (dataMessage.definitionMessage.globalMessageNumber) {
        case 13:
        case 22:
        case 79:
        case 104:
        case 113:
        case 140:
        case 141:
        case 147:
        case 216:
          break; // Garmin uses global message numbers, which are not specified
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
          debugger();
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
    final startDate = now - 20 * 86400;

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

  static Future<List<Activity>> all({@required Athlete athlete}) async {
    var dbActivityList =
        await athlete.db.getDbActivities().orderByDesc('stravaId').toList();
    var activities = dbActivityList
        .map((dbActivity) => Activity.fromDb(dbActivity))
        .toList();
    return activities;
  }
}
