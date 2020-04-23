import 'package:flutter/material.dart';
import 'package:encrateia/utils/db.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Setup {
  static init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Db.create().connect();
    await createHintFile();
  }

  static createHintFile() async {
    if (Platform.isAndroid) {
      var directories = await getExternalStorageDirectories();
      var hintFile = File('${directories[0].path}/put_your_fit_files_here.txt');
      await hintFile.writeAsString(
          'This is the directory where Encrateia can pickup .fit-files from.');
    } else {
      var directory = await getApplicationDocumentsDirectory();
      var hintFile = File('${directory.path}/put_your_fit_files_here.txt');
      await hintFile.writeAsString(
          'This is the directory where Encrateia can pickup .fit-files from.');
    }
  }
}
