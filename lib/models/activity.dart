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
import 'package:encrateia/utils/data_message_utils.dart';
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
      ..save();

    notifyListeners();
  }

  String toString() => '$db.name $db.startTime';

  Duration movingDuration() => Duration(seconds: db.movingTime ?? 0);
  DateTime startDateTime() => DateTime.parse(db.startTime);

  download({@required Athlete athlete}) async {
    int statusCode = await FitDownload.byId(
      id: db.stravaId.toString(),
      athlete: athlete,
    );
    print("Download status code $statusCode.");

    setState("downloaded");
  }

  setState(String state) {
    db.state = state;
    db.save();
    notifyListeners();
  }

  parse({@required Athlete athlete}) async {
    var appDocDir = await getApplicationDocumentsDirectory();
    print("Starting to parse activity ${db.stravaId}.");
    var fitFile = FitFile(path: appDocDir.path + '/${db.stravaId}.fit').parse();
    print("Parsing activity ${db.stravaId} done.");

    for (var dataMessage in fitFile.dataMessages) {
      if (dataMessage.definitionMessage.globalMessageName == null) {
        switch (dataMessage.definitionMessage.globalMessageNumber) {
          case 13:
          case 22:
          case 79:
          case 104:
          case 141:
          case 147:
            break; // Garmin uses global message numbers, which are not specified
          default:
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
            print(dataMessage.values.map((v) => v.fieldName).toList());
            debugger();
            Lap(dataMessage: dataMessage, activity: this, eventId: 0);
            break;

          default:
            debugger();
        }
      }
    }
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
