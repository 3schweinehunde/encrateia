import 'package:encrateia/models/log.dart';
import 'package:encrateia/screens/show_log_detail_screen.dart';
import 'package:encrateia/utils/PQText.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';

class LogListScreen extends StatefulWidget {
  const LogListScreen({
    Key key,
    @required this.logs,
  }) : super(key: key);

  final List<Log> logs;

  @override
  _LogListScreenState createState() => _LogListScreenState();
}

class _LogListScreenState extends State<LogListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.lap,
        title: const Text('Log Messages'),
      ),
      body: SafeArea(
        child: DataTable(
          columnSpacing: 5,
          showCheckboxColumn: false,
          onSelectAll: (_) {},
          columns: const <DataColumn>[
            DataColumn(label: Text('DateTime'), numeric: false),
            DataColumn(label: Text('Message'), numeric: false),
            DataColumn(label: Text('Method'), numeric: false),
          ],
          rows: widget.logs.map((Log log) {
            return DataRow(
              key: ValueKey<int>(log.id),
              onSelectChanged: (bool selected) {
                if (selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) =>
                          ShowLogDetailScreen(log: log),
                    ),
                  );
                }
              },
              cells: <DataCell>[
                DataCell(PQText(
                  value: log.dateTime,
                  pq: PQ.dateTime,
                  format: DateTimeFormat.compact,
                )),
                DataCell(Text(log.message)),
                DataCell(Text(log.method)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
