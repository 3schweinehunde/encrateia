import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'utils/db.dart';

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Db.create().connect();
  await _createHintFile();
}

Future<void> _createHintFile() async {
  if (Platform.isAndroid) {
    final List<Directory> directories =
        await (getExternalStorageDirectories()) ?? [];
    final File hintFile =
        File('${directories[0].path}/put_your_fit_files_here.txt');
    await hintFile.writeAsString(
        'This is the directory where Encrateia can pickup .fit-files from.');
  } else {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File hintFile = File('${directory.path}/put_your_fit_files_here.txt');
    await hintFile.writeAsString(
        'This is the directory where Encrateia can pickup .fit-files from.');
  }
}
