import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/utils/db.dart';
import 'package:encrateia/model/model.dart';
import 'package:strava_flutter/Models/detailedAthlete.dart';

class Athlete extends Model {
  int id;
  String firstName;
  String lastName;
  String state = "undefined";
  String stravaUsername;
  String photoPath;
  int stravaId;

  Athlete();
  String toString() => '$firstName $lastName ($stravaId)';

  updateFromStravaAthlete(DetailedAthlete athlete) {
    firstName = athlete.firstname;
    lastName = athlete.lastname;
    state = athlete.state;
    stravaId = athlete.id;
    stravaUsername = athlete.username;
    photoPath = athlete.profile;
    state = "unsaved";
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

  persist() async {
    await Db().connect();
    await DbAthlete(
            firstName: firstName,
            lastName: lastName,
            stravaId: stravaId,
            stravaUsername: stravaUsername,
            photoPath: photoPath)
        .save();
  }

  static Athlete of(BuildContext context) => ScopedModel.of<Athlete>(context);
}
