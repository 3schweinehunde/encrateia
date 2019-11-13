import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path_provider/path_provider.dart';

abstract class FitDownload {
  static byId(String id) async {

    final uri = 'https://www.strava.com/activities/#{id}/export_original';
    var rep = await http.get(uri);

    if (rep.statusCode == 200) {
      final file = await _localFile(id);
      file.writeAsString(rep.body);

      return rep.contentLength.toString() + " Bytes written";
    } else {
      return rep.statusCode.toString() + rep.reasonPhrase;
    }
  }

  static Future<File> _localFile(id) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File(directory.path + id + '.fit');
    return file;
  }
}

