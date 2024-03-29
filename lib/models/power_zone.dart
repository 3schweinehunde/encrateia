import 'package:sqfentity_gen/sqfentity_gen.dart';
import '/model/model.dart' show DbPowerZone;
import '/models/power_zone_schema.dart';

class PowerZone {
  PowerZone(
      {required PowerZoneSchema powerZoneSchema,
      String? name,
      int? lowerPercentage,
      int? upperPercentage,
      int? lowerLimit,
      int? upperLimit,
      int? color}) {
    _db = DbPowerZone()
      ..powerZoneSchemataId = powerZoneSchema.id
      ..name = name ?? 'My Zone'
      ..lowerLimit = lowerLimit ?? 70
      ..upperLimit = upperLimit ?? 100
      ..lowerPercentage = lowerPercentage ?? 0
      ..upperPercentage = upperPercentage ?? 0
      ..color = color ?? 0xFFFFc107;

    if (lowerPercentage != null) {
      _db.lowerLimit = (lowerPercentage * powerZoneSchema.base! / 100).round();
    }
    if (upperPercentage != null) {
      _db.upperLimit = (upperPercentage * powerZoneSchema.base! / 100).round();
    }
  }

  PowerZone._fromDb(this._db);
  late DbPowerZone _db;

  int? get id => _db.id;
  String? get name => _db.name;
  int? get color => _db.color;
  int? get lowerLimit => _db.lowerLimit;
  int? get lowerPercentage => _db.lowerPercentage;
  int? get upperLimit => _db.upperLimit;
  int? get upperPercentage => _db.upperPercentage;

  set id(int? value) => _db.id = value;
  set color(int? value) => _db.color = value;
  set lowerLimit(int? value) => _db.lowerLimit = value;
  set lowerPercentage(int? value) => _db.lowerPercentage = value;
  set name(String? value) => _db.name = value;
  set powerZoneSchemataId(int? value) => _db.powerZoneSchemataId = value;
  set upperLimit(int? value) => _db.upperLimit = value;
  set upperPercentage(int? value) => _db.upperPercentage = value;

  @override
  String toString() => '< PowerZone | $name | $lowerLimit >';

  Future<BoolResult> delete() async => await _db.delete();
  Future<int?> save() async => await _db.save();

  static Future<BoolCommitResult> upsertAll(List<PowerZone> powerZones) async {
    return await DbPowerZone().upsertAll(
        powerZones.map((PowerZone powerZone) => powerZone._db).toList());
  }

  static PowerZone exDb(DbPowerZone db) => PowerZone._fromDb(db);
}
