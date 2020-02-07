import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';
import 'package:encrateia/models/activity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Athlete extends ChangeNotifier {
  String email;
  String password;
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
      ..state = "fromStrava";
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
}
