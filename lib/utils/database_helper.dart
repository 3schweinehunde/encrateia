import 'package:encrateia/models/athlete.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static SqfliteAdapter _adapter;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<SqfliteAdapter> get adapter async {
    if (_adapter == null) _adapter = await getAdapter();
    return _adapter;
  }

  Future<SqfliteAdapter> getAdapter() async {
    var db = await openDatabase('encrateia.db');
    var path = await getDatabasesPath();

    SqfliteAdapter adapter = new SqfliteAdapter("$path $db");
    await adapter.connect();

    final athleteBean = AthleteBean(adapter);
    try {
      await db.query(athleteBean.tableName);
    } catch (e) {
      await athleteBean.createTable();
    }
    return adapter;
  }
}
