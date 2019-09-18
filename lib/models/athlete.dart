import 'package:jaguar_query/jaguar_query.dart';
import 'package:flutter/material.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:encrateia/utils/database_helper.dart';

part 'athlete.jorm.dart';

class Athlete extends Model {
  @PrimaryKey()
  int id;
  String firstName;
  String lastName;
  String state = "";
  String stravaUsername;
  String photoPath;
  int stravaId;

  Athlete();

  static const String tableName = '_athlete';

  String toString() => '$firstName $lastName ($id)';

  void set({firstName, lastName, state, stravaId, stravaUsername, photoPath}) {
    this
      ..id = stravaId
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
      case "":
        text = "Loading athlete data from Strava ...";
        break;
      case "loaded":
        text = "Strava data loaded successfully.";
        break;
      default:
        text = "Unknown State, should have never come here.";
    }
    return text;
  }

  persist() async{
    var databaseHelper = DatabaseHelper();
    var adapter = await databaseHelper.adapter;
    AthleteBean(adapter).insert(this);
  }

  static Athlete of(BuildContext context) => ScopedModel.of<Athlete>(context);
}

@GenBean()
class AthleteBean extends Bean<Athlete> with _AthleteBean {
  AthleteBean(Adapter _adapter) : super(_adapter);

  final String tableName = 'athletes';
}
