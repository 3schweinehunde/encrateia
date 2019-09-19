import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/utils/db.dart';
import 'package:encrateia/model/model.dart';

class Athlete extends Model {
  int id;
  String firstName;
  String lastName;
  String state = "undefined";
  String stravaUsername;
  String photoPath;
  int stravaId;

  Athlete();
  String toString() => '$firstName $lastName ($id)';

  void set({firstName, lastName, state, stravaId, stravaUsername, photoPath}) {
    this
      ..firstName = firstName
      ..lastName = lastName
      ..state = state
      ..stravaId = stravaId
      ..stravaUsername = stravaUsername
      ..photoPath = photoPath;
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
        text = "Unknown State, should have never come here.";
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
