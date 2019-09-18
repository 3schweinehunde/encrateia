import 'package:sqflite/sqflite.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

class Database {
  static connection() async {
    SqfliteAdapter adapter = new SqfliteAdapter(await getDatabasesPath());
    await adapter.connect();
    return adapter;
  }
}
