import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:encrateia/model/model.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

// to get something as close as possible to the current method name, use:
// StackTrace.current.toString()

class Log {
  Log({
    @required String message,
    @required String method,
    @required String stackTrace,
    String comment,
  }) {
    _db = DbLog()
      ..comment = comment
      ..method = method
      ..message = message
      ..stackTrace = stackTrace
      ..dateTime = DateTime.now();

    log(message, name: method);
  }
  Log._fromDb(this._db);

  DbLog _db;

  DateTime get dateTime => _db.dateTime;
  String get comment => _db.comment;
  String get message => _db.message;
  String get method => _db.method;
  String get stackTrace => _db.stackTrace;
  int get id => _db?.id;

  @override
  String toString() => '< Log | $dateTime | $message >';

  static Future<List<Log>> all() async {
    final List<DbLog> dbLogList =
        await DbLog().select().orderByDesc('dateTime').toList();
    return dbLogList.map(Log.exDb).toList();
  }

  static Future<List<Log>> one() async {
    final List<DbLog> dbLogList = await DbLog().select().top(1).toList();
    return dbLogList.map(Log.exDb).toList();
  }

  Future<BoolResult> delete() async => await _db.delete();
  Future<int> save() async => await _db.save();

  static Future<void> deleteAll() async {
    final List<Log> logs = await all();
    for (final Log log in logs) {
      await log.delete();
    }
  }

  static Log exDb(DbLog db) => Log._fromDb(db);
}
