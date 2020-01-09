import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'package:encrateia/utils/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Db.create().connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrateia',
      theme: ThemeData(
        primarySwatch: Colors.orange, // #ff9800
      ),
      home: Dashboard(),
    );
  }
}
