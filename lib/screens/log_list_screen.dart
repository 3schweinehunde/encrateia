import 'package:encrateia/models/log.dart';
import 'package:encrateia/screens/show_log_detail_screen.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';

class LogListScreen extends StatefulWidget {
  const LogListScreen({
    Key key,
  }) : super(key: key);

  @override
  _LogListScreenState createState() => _LogListScreenState();
}

class _LogListScreenState extends State<LogListScreen> {
  List<Log> logs = <Log>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.lap,
        title: const Text('Log Messages'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(logs.length.toString() + ' log entries'),
                const SizedBox(width: 20),
                MyButton.delete(
                  child: const Text('Delete all log entries'),
                  onPressed: () async {
                    await Log.deleteAll();
                    getData();
                  },
                ),
              ],
            ),
            DataTable(
              columnSpacing: 5,
              showCheckboxColumn: false,
              onSelectAll: (_) {},
              columns: const <DataColumn>[
                DataColumn(label: Text('DateTime'), numeric: false),
                DataColumn(label: Text('Message'), numeric: false),
                DataColumn(label: Text('Method'), numeric: false),
                DataColumn(label: Text('Details'), numeric: false),
                DataColumn(label: Text('Delete'), numeric: false),
              ],
              rows: logs.map((Log log) {
                return DataRow(
                  key: ValueKey<int>(log.id),
                  cells: <DataCell>[
                    DataCell(PQText(
                      value: log.dateTime,
                      pq: PQ.dateTime,
                      format: DateTimeFormat.compact,
                    )),
                    DataCell(Text(log.message)),
                    DataCell(Text(log.method)),
                    DataCell(MyButton.navigate(
                      child: const Text('Details'),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) =>
                                ShowLogDetailScreen(log: log),
                          ),
                        );
                      },
                    )),
                    DataCell(MyButton.delete(
                      onPressed: () async {
                        await log.delete();
                        getData();
                      },
                    ))
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    logs = await Log.all();
    setState(() {});
  }
}
