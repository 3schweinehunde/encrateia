import 'package:encrateia/setup.dart';
import 'package:encrateia/utils/my_theme.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard.dart';

void main() async {
  await Setup.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrateia',
      theme: MyTheme.call(),
      home: Dashboard(),
    );
  }
}
