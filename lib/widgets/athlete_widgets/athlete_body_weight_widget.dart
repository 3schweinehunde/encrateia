import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '/models/athlete.dart';
import '/models/weight.dart';
import '/screens/add_weight_screen.dart';
import '/utils/pg_text.dart';
import '/utils/enums.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button.dart';
import '/utils/my_button_style.dart';

class AthleteBodyWeightWidget extends StatefulWidget {
  const AthleteBodyWeightWidget({
    this.athlete,
    this.callBackFunction,
  });

  final Athlete? athlete;
  final Function? callBackFunction;

  @override
  _AthleteBodyWeightWidgetState createState() =>
      _AthleteBodyWeightWidgetState();
}

class _AthleteBodyWeightWidgetState extends State<AthleteBodyWeightWidget> {
  List<Weight> weights = <Weight>[];
  int offset = 0;
  int? rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (weights != null) {
      if (weights.isNotEmpty) {
        rows = (weights.length < 8) ? weights.length : 8;
        return SingleChildScrollView(
          child: PaginatedDataTable(
            header: Row(
              children: <Widget>[
                MyButton.add(
                  child: const Text('New weighting'),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) => AddWeightScreen(
                          weight: Weight(
                            athlete: widget.athlete!,
                          ),
                          numberOfWeights: weights.length,
                        ),
                      ),
                    );
                    getData();
                  },
                ),
                const Spacer(),
              ],
            ),
            columns: const <DataColumn>[
              DataColumn(label: Text('Date')),
              DataColumn(
                label: Text('Weight'),
                numeric: true,
              ),
              DataColumn(label: Text('Edit'))
            ],
            rowsPerPage: 8,
            source: BodyWeightSource(
              weights: weights,
              context: context,
              callback: getData,
            ),
          ),
        );
      } else {
        return Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Text('''
No weight data so far:
                
You can import your historic weight data by putting a weights.csv-file in the App's document directory.
It's the one with a file named "put_your_fit_files_here.txt" inside.

Put one date and weight per line in the following format:
2020-04-28,75.3

Or you can simply enter your current weight using the New Weighting button. 
Please also enter at least a rough estimate default weight for your former activities.
You can change these later.
                '''),
            ),
            Row(
              children: <Widget>[
                const Spacer(),
                ElevatedButton(
                  style: MyButtonStyle.raisedButtonStyle(color: Colors.orange),
                  child: const Text('Import Weights'),
                  onPressed: () => importWeights(),
                ),
                const Spacer(),
                MyButton.add(
                    child: const Text('New weighting'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => AddWeightScreen(
                            weight: Weight(athlete: widget.athlete!),
                            numberOfWeights: weights.length,
                          ),
                        ),
                      );
                      getData();
                    }),
                const Spacer(),
              ],
            )
          ],
        );
      }
    } else {
      return const Center(
        child: Text('loading'),
      );
    }
  }

  Future<void> getData() async {
    final Athlete athlete = widget.athlete!;
    weights = await athlete.weights;
    if (widget.callBackFunction != null) {
      await widget.callBackFunction!();
    }
    setState(() {});
  }

  Future<void> importWeights() async {
    Directory directory;
    Weight weight;

    if (Platform.isAndroid) {
      final List<Directory> directories = await (getExternalStorageDirectories() as Future<List<Directory>>);
      directory = directories[0];
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final String pathToFile = directory.path + '/weights.csv';
    // ignore: avoid_slow_async_io
    final bool isFile = await FileSystemEntity.isFile(pathToFile);
    if (isFile == true) {
      final Stream<List<int>> input = File(pathToFile).openRead();
      final List<List<dynamic>> weightings = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(eol: '\n'))
          .toList();
      for (final List<dynamic> weighting in weightings) {
        weight = Weight(athlete: widget.athlete!);
        weight.date = DateTime.utc(
          int.parse((weighting[0] as String).split('-')[0]),
          int.parse((weighting[0] as String).split('-')[1]),
          int.parse((weighting[0] as String).split('-')[2]),
        );
        weight.value = double.parse(weighting[1] as String);
        await weight.save();
      }
      await getData();
    }
  }
}

class BodyWeightSource extends DataTableSource {
  BodyWeightSource({
    required this.weights,
    required this.context,
    required this.callback,
  });

  final List<Weight> weights;
  final BuildContext context;
  final Function callback;

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(PQText(
          value: weights[index].date,
          pq: PQ.dateTime,
          format: DateTimeFormat.longDate,
        )),
        DataCell(PQText(value: weights[index].value, pq: PQ.weight)),
        DataCell(MyIcon.edit, onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<BuildContext>(
              builder: (BuildContext context) => AddWeightScreen(
                weight: weights[index],
                numberOfWeights: weights.length,
              ),
            ),
          );
          callback();
        })
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => weights.length;

  @override
  int get selectedRowCount => 0;
}
