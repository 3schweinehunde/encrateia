import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Athlete extends ChangeNotifier {
  String email;
  String password;
  DbAthlete db;

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
      ..state = athlete.state;
    notifyListeners();
  }

  String get stateText {
    switch (db.state) {
      case "undefined":
        return "Loading athlete data from Strava ...";
      case "unsaved":
        return "Strava data loaded successfully.";
      default:
        return "Unknown state, should have never come here.";
    }
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
