import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:scoped_model/scoped_model.dart';

part 'athlete.jorm.dart';

class Athlete extends Model {
  @PrimaryKey()
  String id;
  String firstName;
  int stravaId;

  Athlete();
  Athlete.make(this.id, this.firstName, this.stravaId);

  static const String tableName = '_athlete';
  String toString() => '$firstName ($id)';

  void setData({firstName}) {
    this.firstName = firstName;
    notifyListeners();
  }
}

@GenBean()
class AthleteBean extends Bean<Athlete> with _AthleteBean {
  AthleteBean(Adapter _adapter) : super(_adapter);

  final String tableName = 'athletes';
}