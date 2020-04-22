import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/models/weight.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class Athlete extends ChangeNotifier {
  String email;
  String password;
  String firstName;
  String lastName;
  DbAthlete db = DbAthlete();

  Athlete();
  Athlete.fromDb(this.db);

  String toString() => '$db.firstName $db.lastName ($db.stravaId)';

  updateFromStravaAthlete(DetailedAthlete athlete) {
    db
      ..firstName = athlete.firstname
      ..lastName = athlete.lastname
      ..stravaId = athlete.id
      ..stravaUsername = athlete.username
      ..photoPath = athlete.profile
      ..geoState = athlete.state
      ..state = "fromStrava"
      ..downloadInterval = 21;
    notifyListeners();
  }

  setupStandaloneAthlete() async {
    db
      ..state = "standalone"
      ..firstName = "Jane"
      ..lastName = "Doe";
    await db.save();
    notifyListeners();
  }

  String get stateText {
    switch (db.state) {
      case "new":
        return "Loading athlete data from Strava ...";
      case "unsaved":
        return "Strava data loaded successfully.";
      case "fromStrava":
        return "Data received from Strava.";
      default:
        return "Unknown state ${db.state}, should have never come here.";
    }
  }

  storeCredentials() async {
    final storage = FlutterSecureStorage();
    await storage.write(key: "email", value: email);
    await storage.write(key: "password", value: password);
    notifyListeners();
  }

  readCredentials() async {
    final storage = FlutterSecureStorage();
    email = await storage.read(key: "email");
    password = await storage.read(key: "password");
    notifyListeners();
  }

  static Future<List<Athlete>> all() async {
    List<DbAthlete> dbAthleteList = await DbAthlete().select().toList();
    return dbAthleteList.map((dbAthlete) => Athlete.fromDb(dbAthlete)).toList();
  }

  get activities => Activity.all(athlete: this);
  get weights => Weight.all(athlete: this);

  delete() async {
    var appDocDir = await getApplicationDocumentsDirectory();

    for (Activity activity in await activities) {
      await activity.db.getDbEvents().delete();
      await activity.db.getDbLaps().delete();
      await File(appDocDir.path + '/${db.stravaId}.fit').delete();
    }
    await db.getDbActivities().delete();
    await db.delete();
    notifyListeners();
  }

  save() async {
    await db.save();
    notifyListeners();
  }
}
