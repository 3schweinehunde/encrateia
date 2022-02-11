import 'package:flutter/material.dart';

import 'screens/dashboard.dart';
import 'setup.dart';
import 'utils/my_theme.dart';

Future<void> main() async {
  await setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrateia',
      theme: myTheme(),
      home: const Dashboard(),
    );
  }
}
