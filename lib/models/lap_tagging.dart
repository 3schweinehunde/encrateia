import 'package:sqfentity_gen/sqfentity_gen.dart';
import '/model/model.dart' show DbLapTagging;
import '/models/lap.dart';
import '/models/tag.dart';

class LapTagging {
  LapTagging({
    required Lap lap,
    required Tag tag,
    bool? system,
  }) {
    _db = DbLapTagging()
      ..lapsId = lap.id
      ..tagsId = tag.id
      ..system = system ?? false;
  }

  LapTagging._fromDb(this._db);

  DbLapTagging? _db;

  int? get id => _db?.id;
  int? get lapsId => _db!.lapsId;
  int? get tagsId => _db!.tagsId;

  @override
  String toString() => '< LapTagging | lapId $lapsId | tagId $tagsId >';

  Future<BoolResult> delete() async => await _db!.delete();
  Future<int?> save() async => await _db!.save();

  static Future<LapTagging> createBy({
    required Lap lap,
    required Tag tag,
    bool? system,
  }) async {
    final DbLapTagging? dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();

    if (dbLapTagging != null) {
      return LapTagging._fromDb(dbLapTagging);
    } else {
      final LapTagging lapTagging = LapTagging(
        lap: lap,
        tag: tag,
        system: system ?? false,
      );
      await lapTagging.save();
      return lapTagging;
    }
  }

  static Future<LapTagging?> getBy({
    required Lap lap,
    required Tag tag,
  }) async {
    final DbLapTagging? dbLapTagging = await DbLapTagging()
        .select()
        .lapsId
        .equals(lap.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle();
    return (dbLapTagging != null) ? LapTagging._fromDb(dbLapTagging) : null;
  }

  static Future<void> deleteBy({
    required Lap lap,
    required Tag tag,
  }) async {
    final DbLapTagging dbLapTagging = await (DbLapTagging()
        .select()
        .lapsId
        .equals(lap.id)
        .and
        .tagsId
        .equals(tag.id)
        .toSingle() as Future<DbLapTagging>);
    await dbLapTagging.delete();
  }

  static LapTagging exDb(DbLapTagging db) => LapTagging._fromDb(db);
}
