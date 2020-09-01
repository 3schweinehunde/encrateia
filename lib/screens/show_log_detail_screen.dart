import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/log.dart';

class ShowLogDetailScreen extends StatelessWidget {
  const ShowLogDetailScreen({
    Key key,
    this.log,
  }) : super(key: key);

  final Log log;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.log,
        title: const Text('Log Message'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: PQText(
              value: log.dateTime,
              pq: PQ.dateTime,
              format: DateTimeFormat.longDateTime,
            ),
            subtitle: const Text('Point in Time'),
          ),
          ListTile(
            title: Text(log.message),
            subtitle: const Text('Message'),
          ),
          ListTile(
            title: Text(log.method),
            subtitle: const Text('Method'),
          ),
          ListTile(
            title: Text(log.comment),
            subtitle: const Text('Comment'),
          ),
          ListTile(
            title: Text(log.stackTrace),
            subtitle: const Text('stacktrace'),
          ),
        ],
      ),
    );
  }
}
