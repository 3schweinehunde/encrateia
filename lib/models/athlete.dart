import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:scoped_model/scoped_model.dart';

part 'athlete.jorm.dart';

class Athlete extends Model {
  @PrimaryKey()
  String id;
  String firstName;
  String lastName;
  String state = "";
  String stravaUsername;
  String photoPath;

  int stravaId;

  Athlete();

  Athlete.make(this.id, this.firstName, this.stravaId);

  static const String tableName = '_athlete';

  String toString() => '$firstName ($id)';

  void set({firstName, lastName, state, stravaId, stravaUsername, photoPath}) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.state = state;
    this.stravaId = stravaId;
    this.stravaUsername = stravaUsername;
    this.photoPath = photoPath;
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
}

@GenBean()
class AthleteBean extends Bean<Athlete> with _AthleteBean {
  AthleteBean(Adapter _adapter) : super(_adapter);

  final String tableName = 'athletes';
}