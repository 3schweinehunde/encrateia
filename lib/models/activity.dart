import 'package:encrateia/models/fit_download.dart';
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

class Activity extends ChangeNotifier {
  DbActivity db;

  Activity();
  Activity.fromDb(this.db);

  Activity.fromStrava(StravaActivity.SummaryActivity summaryActivity) {
    db = DbActivity()
      ..name = summaryActivity.name
      ..movingTime = summaryActivity.movingTime
      ..type = summaryActivity.type
      ..distance = summaryActivity.distance.toInt()
      ..stravaId = summaryActivity.id
      ..startTime = summaryActivity.startDate
      ..movingTime = summaryActivity.movingTime
      ..save();

    notifyListeners();
  }

  String toString() => '$db.name $db.startTime';
  Duration movingDuration() => Duration(seconds: db.movingTime ?? 0);

  download({@required Athlete athlete}) async {
    int statusCode = await FitDownload.byId(
      id: db.stravaId.toString(),
      athlete: athlete,
    );
    print("Download status code $statusCode.");

    setState("downloaded");
  }

  setState(String state) {
    db
      ..state = state
      ..save();

    notifyListeners();
  }

  parse({@required Athlete athlete}) async {
    var counter = 0;
    var appDocDir = await getApplicationDocumentsDirectory();
    print("Starting to parse activity ${db.stravaId}.");
    var fitFile = FitFile(path: appDocDir.path + '/${db.stravaId}.fit').parse();
    print("Parsing activity ${db.stravaId} done.");

    for (var dataMessage in fitFile.dataMessages) {
      counter = counter + 1;
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
              ..serialNumber = dataMessage.get('serial_number').round()
              ..timeCreated =
                  dateTimeFromStrava(dataMessage.get('time_created'))
              ..save();
            notifyListeners();
            break;

          case "sport":
            db
              ..sportName = dataMessage.get('name')
              ..sport = dataMessage.get('sport')
              ..subSport = dataMessage.get('sub_sport')
              ..save();
            notifyListeners();
            break;

          case "event":
            Event(dataMessage: dataMessage, activity: this);
            break;

          case "record":
            Event.fromRecord(dataMessage: dataMessage, activity: this);
            break;

          case "lap":
            var event = Event.fromLap(dataMessage: dataMessage, activity: this);
            var eventId = await event.db.save();
            Lap(dataMessage: dataMessage, activity: this, eventId: eventId);
            break;

          case "session":
            db
              ..timeStamp = dateTimeFromStrava(dataMessage.get('timestamp'))
              ..startTime = dateTimeFromStrava(dataMessage.get('start_time'))
              ..startPositionLat = dataMessage.get('start_position_lat')
              ..startPositionLong = dataMessage.get('start_position_long')
              ..totalElapsedTime = dataMessage.get('total_elapsed_time').round()
              ..totalTimerTime = dataMessage.get('total_timer_time').round()
              ..totalDistance = dataMessage.get('total_distance').round()
              ..totalStrides = dataMessage.get('total_strides').round()
              ..necLat = dataMessage.get('nec_lat')
              ..necLong = dataMessage.get('nec_long')
              ..swcLat = dataMessage.get('swc_lat')
              ..swcLong = dataMessage.get('swc_long')
              ..totalCalories = dataMessage.get('total_calories').round()
              ..avgSpeed = dataMessage.get('avg_speed')
              ..maxSpeed = dataMessage.get('max_speed')
              ..totalAscent = dataMessage.get('total_ascent').round()
              ..totalDescent = dataMessage.get('total_descent').round()
              ..maxRunningCadence =
                  dataMessage.get('max_running_cadence').round()
              ..firstLapIndex = dataMessage.get('first_lap_index').round()
              ..numLaps = dataMessage.get('num_laps').round()
              ..event = dataMessage.get('event').toString()
              ..eventType = dataMessage.get('event_type')
              ..eventGroup = dataMessage.get('event_group').round()
              ..trigger = dataMessage.get('trigger')
              ..avgVerticalOscillation =
                  dataMessage.get('avg_vertical_oscillation')
              ..avgStanceTimePercent =
                  dataMessage.get('avg_stance_time_percent')
              ..avgStanceTime = dataMessage.get('avg_stance_time')
              ..sport = dataMessage.get('sport')
              ..subSport = dataMessage.get('sub_sport')
              ..avgHeartRate = dataMessage.get('avg_heart_rate').round()
              ..maxHeartRate = dataMessage.get('max_heart_rate').round()
              ..avgRunningCadence = dataMessage.get('avg_running_cadence')
              ..totalTrainingEffect =
                  dataMessage.get('total_training_effect').round()
              ..avgTemperature = dataMessage.get('avg_temperature').round()
              ..maxTemperature = dataMessage.get('max_temperature').round()
              ..avgFractionalCadence = dataMessage.get('avg_fractional_cadence')
              ..maxFractionalCadence = dataMessage.get('max_fractional_cadence')
              ..totalFractionalCycles =
                  dataMessage.get('total_fractional_cycles')
              ..save();
            notifyListeners();
            break;

          case "activity":
            db
              ..numSessions = dataMessage.get('num_sessions').round()
              ..localTimestamp =
                  dateTimeFromStrava(dataMessage.get('local_timestamp'))
              ..save();
            notifyListeners();
            break;

          default:
            print("Messages of type "
                "${dataMessage.definitionMessage.globalMessageName} "
                "are not implemented yet.");
            print(dataMessage.values.map((v) => v.fieldName).toList());
            debugger();
            print(counter);
        }
      }
    }
    print("All elements of activity ${db.stravaId} persisted.");
  }

  static queryStrava() async {
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

    for (StravaActivity.SummaryActivity summaryActivity in summaryActivities) {
      Activity.fromStrava(summaryActivity);
    }
  }

  static Future<List<Activity>> all() async {
    List<DbActivity> dbActivityList = await DbActivity().select().toList();
    return dbActivityList
        .map((dbActivity) => Activity.fromDb(dbActivity))
        .toList();
  }
}
