import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'package:encrateia/setup.dart';

void main() async {
  await Setup.init();
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
