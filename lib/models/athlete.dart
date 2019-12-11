import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Athlete extends ChangeNotifier {
  String state = "undefined";
  String email;
  String password;
  DbAthlete db;

  Athlete();

  Athlete.fromDb(DbAthlete dbAthlete) {
    this..db = dbAthlete
        ..state = "fromDatabase";
  }

  String toString() => '$db.firstName $db.lastName ($db.stravaId)';

  updateFromStravaAthlete(DetailedAthlete athlete) {
    db.firstName = athlete.firstname;
    db.lastName = athlete.lastname;
    db.stravaId = athlete.id;
    db.stravaUsername = athlete.username;
    db.photoPath = athlete.profile;
    state = athlete.state;
    notifyListeners();
  }

  String get stateText {
    String text;
    switch (state) {
      case "undefined":
        text = "Loading athlete data from Strava ...";
        break;
      case "unsaved":
        text = "Strava data loaded successfully.";
        break;
      default:
        text = "Unknown state, should have never come here.";
    }
    return text;
  }

  store_credentials() async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: "email", value: email);
    await storage.write(key: "password", value: password);
  }

  Future<Athlete> read_credentials() async {
    final storage = new FlutterSecureStorage();
    email = await storage.read(key: "email");
    password = await storage.read(key: "password");
  }

  static Future<List<Athlete>> all() async {
    List<DbAthlete> dbAthleteList = await DbAthlete().select().toList();
    return dbAthleteList.map((dbAthlete) => Athlete.fromDb(dbAthlete)).toList();
  }
}
