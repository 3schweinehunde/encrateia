// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _AthleteBean implements Bean<Athlete> {
  final id = IntField('id');
  final firstName = StrField('first_name');
  final lastName = StrField('last_name');
  final state = StrField('state');
  final stravaUsername = StrField('strava_username');
  final photoPath = StrField('photo_path');
  final stravaId = IntField('strava_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        firstName.name: firstName,
        lastName.name: lastName,
        state.name: state,
        stravaUsername.name: stravaUsername,
        photoPath.name: photoPath,
        stravaId.name: stravaId,
      };
  Athlete fromMap(Map map) {
    Athlete model = Athlete();
    model.id = adapter.parseValue(map['id']);
    model.firstName = adapter.parseValue(map['first_name']);
    model.lastName = adapter.parseValue(map['last_name']);
    model.state = adapter.parseValue(map['state']);
    model.stravaUsername = adapter.parseValue(map['strava_username']);
    model.photoPath = adapter.parseValue(map['photo_path']);
    model.stravaId = adapter.parseValue(map['strava_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Athlete model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(firstName.set(model.firstName));
      ret.add(lastName.set(model.lastName));
      ret.add(state.set(model.state));
      ret.add(stravaUsername.set(model.stravaUsername));
      ret.add(photoPath.set(model.photoPath));
      ret.add(stravaId.set(model.stravaId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(firstName.name))
        ret.add(firstName.set(model.firstName));
      if (only.contains(lastName.name)) ret.add(lastName.set(model.lastName));
      if (only.contains(state.name)) ret.add(state.set(model.state));
      if (only.contains(stravaUsername.name))
        ret.add(stravaUsername.set(model.stravaUsername));
      if (only.contains(photoPath.name))
        ret.add(photoPath.set(model.photoPath));
      if (only.contains(stravaId.name)) ret.add(stravaId.set(model.stravaId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.firstName != null) {
        ret.add(firstName.set(model.firstName));
      }
      if (model.lastName != null) {
        ret.add(lastName.set(model.lastName));
      }
      if (model.state != null) {
        ret.add(state.set(model.state));
      }
      if (model.stravaUsername != null) {
        ret.add(stravaUsername.set(model.stravaUsername));
      }
      if (model.photoPath != null) {
        ret.add(photoPath.set(model.photoPath));
      }
      if (model.stravaId != null) {
        ret.add(stravaId.set(model.stravaId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, isNullable: false);
    st.addStr(firstName.name, isNullable: false);
    st.addStr(lastName.name, isNullable: false);
    st.addStr(state.name, isNullable: false);
    st.addStr(stravaUsername.name, isNullable: false);
    st.addStr(photoPath.name, isNullable: false);
    st.addInt(stravaId.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Athlete model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Athlete> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Athlete model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<Athlete> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(Athlete model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Athlete> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<Athlete> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Athlete> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
