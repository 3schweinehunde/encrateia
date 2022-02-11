import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/athlete.dart';
import '/models/heart_rate_zone_schema.dart';
import '/screens/add_heart_rate_zone_schema_screen.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button.dart';
import '/utils/my_button_style.dart';

class AthleteHeartRateZoneSchemaWidget extends StatefulWidget {
  const AthleteHeartRateZoneSchemaWidget({
    this.athlete,
    this.callBackFunction,
  });

  final Athlete athlete;
  final Function callBackFunction;

  @override
  _AthleteHeartRateZoneSchemaWidgetState createState() =>
      _AthleteHeartRateZoneSchemaWidgetState();
}

class _AthleteHeartRateZoneSchemaWidgetState
    extends State<AthleteHeartRateZoneSchemaWidget> {
  List<HeartRateZoneSchema> heartRateZoneSchemas = <HeartRateZoneSchema>[];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (heartRateZoneSchemas != null) {
      if (heartRateZoneSchemas.isNotEmpty) {
        rows =
            (heartRateZoneSchemas.length < 8) ? heartRateZoneSchemas.length : 8;
        return Column(
          children: <Widget>[
            Center(
              child: Text(
                '\nHeart Rate Zone Schemas ${offset + 1} - ${offset + rows} '
                'of ${heartRateZoneSchemas.length}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            DataTable(
              headingRowHeight: kMinInteractiveDimension * 0.80,
              dataRowHeight: kMinInteractiveDimension * 0.80,
              columnSpacing: 9,
              columns: const <DataColumn>[
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Name')),
                DataColumn(
                  label: Text('Base (bpm)'),
                  numeric: true,
                ),
                DataColumn(label: Text('Edit')),
              ],
              rows: heartRateZoneSchemas
                  .sublist(offset, offset + rows)
                  .map((HeartRateZoneSchema heartRateZoneSchema) {
                return DataRow(
                  key: ValueKey<int>(heartRateZoneSchema.id),
                  cells: <DataCell>[
                    DataCell(Text(DateFormat('d MMM yyyy')
                        .format(heartRateZoneSchema.date))),
                    DataCell(Text(heartRateZoneSchema.name)),
                    DataCell(Text(heartRateZoneSchema.base.toString())),
                    DataCell(
                      MyIcon.edit,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) =>
                                AddHeartRateZoneSchemaScreen(
                              heartRateZoneSchema: heartRateZoneSchema,
                              numberOfSchemas: heartRateZoneSchemas.length,
                            ),
                          ),
                        );
                        getData();
                      },
                    )
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                const Spacer(),
                MyButton.add(
                    child: const Text('New schema'),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) =>
                              AddHeartRateZoneSchemaScreen(
                            heartRateZoneSchema:
                                HeartRateZoneSchema(athlete: widget.athlete),
                            numberOfSchemas: heartRateZoneSchemas.length,
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
                  onPressed: (offset + rows == heartRateZoneSchemas.length)
                      ? null
                      : () => setState(() {
                            offset + rows < heartRateZoneSchemas.length - rows
                                ? offset = offset + rows
                                : offset = heartRateZoneSchemas.length - rows;
                          }),
                ),
                const Spacer(),
              ],
            ),
            templateButtons(),
          ],
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              const Text('''
No heart rate schema defined so far:
                
You can easily start with a pre defined heartRate schema,
just click on the button below und go from there.

You could also create a schema from scratch.

'''),
              ElevatedButton(
                style: MyButtonStyle.raisedButtonStyle(color: Colors.green),
                child: const Text('New schema'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) =>
                          AddHeartRateZoneSchemaScreen(
                        heartRateZoneSchema:
                            HeartRateZoneSchema(athlete: widget.athlete),
                        numberOfSchemas: heartRateZoneSchemas.length,
                      ),
                    ),
                  );
                  getData();
                },
              ),
              templateButtons(),
            ],
          ),
        );
      }
    } else {
      return const Center(child: Text('loading'));
    }
  }

  Future<void> getData() async {
    final Athlete athlete = widget.athlete;
    heartRateZoneSchemas = await athlete.heartRateZoneSchemas;
    if (widget.callBackFunction != null) {
      await widget.callBackFunction();
    }
    setState(() {});
  }

  Future<void> likeGarmin() async {
    final Athlete athlete = widget.athlete;
    final HeartRateZoneSchema heartRateZoneSchema =
        HeartRateZoneSchema.likeGarmin(athlete: athlete);
    await heartRateZoneSchema.save();
    await heartRateZoneSchema.addGarminZones();
    await getData();
  }

  Future<void> likeStefanDillinger() async {
    final Athlete athlete = widget.athlete;
    final HeartRateZoneSchema heartRateZoneSchema =
        HeartRateZoneSchema.likeStefanDillinger(athlete: athlete);
    await heartRateZoneSchema.save();
    await heartRateZoneSchema.addStefanDillingerZones();
    await getData();
  }

  Widget templateButtons() {
    return Column(children: <Widget>[
      const Divider(),
      const Text('Add heart rate zone schema from template:'),
      ElevatedButton(
        style: MyButtonStyle.raisedButtonStyle(color: Colors.orange),
        child: const Text('like Garmin'),
        onPressed: () => likeGarmin(),
      ),
      ElevatedButton(
        style: MyButtonStyle.raisedButtonStyle(color: Colors.orange),
        child: const Text('like Stefan Dillinger'),
        onPressed: () => likeStefanDillinger(),
      ),
    ]);
  }
}
