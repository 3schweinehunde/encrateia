import 'package:flutter/material.dart';

import 'screens/dashboard.dart';
import 'setup.dart';
import 'utils/my_theme.dart';

Future<void> main() async {
  await setup();
  runApp(const Encrateia());
}

class Encrateia extends StatelessWidget {
  const Encrateia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrateia',
      theme: myTheme(),
      home: const Dashboard(),
    );
  }
}
