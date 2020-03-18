import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'package:encrateia/utils/db.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Db.create().connect();
  await createHintFile();
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

createHintFile() async {
  var directories = await getExternalStorageDirectories();
  var hintFile = File('${directories[0].path}/put_your_fit_files_here.txt');
  await hintFile.writeAsString(
      'This is the directory where Encrateia can pickup .fit-files from.');
}
