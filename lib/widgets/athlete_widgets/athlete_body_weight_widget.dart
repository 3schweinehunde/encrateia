import 'dart:convert';
import 'dart:io';
import 'package:encrateia/screens/add_weight_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

class AthleteBodyWeightWidget extends StatefulWidget {
  const AthleteBodyWeightWidget({this.athlete});

  final Athlete athlete;

  @override
  _AthleteBodyWeightWidgetState createState() =>
      _AthleteBodyWeightWidgetState();
}

class _AthleteBodyWeightWidgetState extends State<AthleteBodyWeightWidget> {
  List<Weight> weights = <Weight>[];
  int offset = 0;
  int rows;

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
        return ListView(
          children: <Widget>[
            DataTable(
              headingRowHeight: kMinInteractiveDimension * 0.80,
              dataRowHeight: kMinInteractiveDimension * 0.80,
              columns: const <DataColumn>[
                DataColumn(label: Text('Date')),
                DataColumn(
                  label: Text('Weight in kg'),
                  numeric: true,
                ),
                DataColumn(label: Text('Edit'))
              ],
              rows: weights.sublist(offset, offset + rows).map((Weight weight) {
                return DataRow(
                  key: ValueKey<int>(weight.db.id),
                  cells: <DataCell>[
                    DataCell(
                        Text(DateFormat('d MMM yyyy').format(weight.db.date))),
                    DataCell(Text(weight.db.value.toString())),
                    DataCell(MyIcon.edit, onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => AddWeightScreen(weight: weight),
                        ),
                      );
                      getData();
                    })
                  ],
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '${offset + 1} - ${offset + rows} '
                'of ${weights.length} ',
                textAlign: TextAlign.right,
              ),
            ),
            Row(
              children: <Widget>[
                const Spacer(),
                MyButton.add(
                    child: const Text('New weighting'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => AddWeightScreen(
                            weight: Weight(athlete: widget.athlete),
                          ),
                        ),
                      );
                      getData();
                    }),
                const Spacer(),
                MyButton.navigate(
                  child: const Text('<<'),
                  onPressed: (offset == 0)
                      ? null
                      : () => setState(() {
                            offset > 8 ? offset = offset - rows : offset = 0;
                          }),
                ),
                const Spacer(),
                MyButton.navigate(
                  child: const Text('>>'),
                  onPressed: (offset + rows == weights.length)
                      ? null
                      : () => setState(() {
                            offset + rows < weights.length - rows
                                ? offset = offset + rows
                                : offset = weights.length - rows;
                          }),
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      } else {
        return ListView(
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
                '''),
            ),
            Row(
              children: <Widget>[
                const Spacer(),
                RaisedButton(
                  // MyIcon.downloadLocal,
                  color: Colors.orange,
                  child: const Text('Import Weights'),
                  onPressed: () => importWeights(),
                ),
                const Spacer(),
                RaisedButton(
                    color: Colors.green,
                    child: const Text('New weighting'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => AddWeightScreen(
                            weight: Weight(athlete: widget.athlete),
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
    final Athlete athlete = widget.athlete;
    weights = await athlete.weights;
    setState(() {});
  }

  Future<void> importWeights() async {
    Directory directory;
    Weight weight;

    if (Platform.isAndroid) {
      final List<Directory> directories = await getExternalStorageDirectories();
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
        weight = Weight(athlete: widget.athlete);
        weight.db.date = DateTime.utc(
          int.parse((weighting[0] as String).split('-')[0]),
          int.parse((weighting[0] as String).split('-')[1]),
          int.parse((weighting[0] as String).split('-')[2]),
        );
        weight.db.value = double.parse(weighting[1] as String);
        await weight.db.save();
      }
      await getData();
    }
  }
}
