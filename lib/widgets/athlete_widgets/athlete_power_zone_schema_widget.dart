import 'package:encrateia/screens/add_power_zone_schema_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_button_style.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:intl/intl.dart';

class AthletePowerZoneSchemaWidget extends StatefulWidget {
  const AthletePowerZoneSchemaWidget({
    this.athlete,
    this.callBackFunction,
  });

  final Athlete athlete;
  final Function callBackFunction;

  @override
  _AthletePowerZoneSchemaWidgetState createState() =>
      _AthletePowerZoneSchemaWidgetState();
}

class _AthletePowerZoneSchemaWidgetState
    extends State<AthletePowerZoneSchemaWidget> {
  List<PowerZoneSchema> powerZoneSchemas = <PowerZoneSchema>[];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (powerZoneSchemas != null) {
      if (powerZoneSchemas.isNotEmpty) {
        rows = (powerZoneSchemas.length < 8) ? powerZoneSchemas.length : 8;
        return Column(
          children: <Widget>[
            Center(
              child: Text(
                '\nPowerZoneSchemas ${offset + 1} - ${offset + rows} '
                'of ${powerZoneSchemas.length}',
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
                  label: Text('Base (W)'),
                  numeric: true,
                ),
                DataColumn(label: Text('Edit')),
              ],
              rows: powerZoneSchemas
                  .sublist(offset, offset + rows)
                  .map((PowerZoneSchema powerZoneSchema) {
                return DataRow(
                  key: ValueKey<int>(powerZoneSchema.id),
                  cells: <DataCell>[
                    DataCell(Text(
                        DateFormat('d MMM yyyy').format(powerZoneSchema.date))),
                    DataCell(Text(powerZoneSchema.name)),
                    DataCell(Text(powerZoneSchema.base.toString())),
                    DataCell(
                      MyIcon.edit,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) =>
                                AddPowerZoneSchemaScreen(
                              powerZoneSchema: powerZoneSchema,
                              numberOfSchemas: powerZoneSchemas.length,
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
                              AddPowerZoneSchemaScreen(
                            powerZoneSchema:
                                PowerZoneSchema(athlete: widget.athlete),
                            numberOfSchemas: powerZoneSchemas.length,
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
                  onPressed: (offset + rows == powerZoneSchemas.length)
                      ? null
                      : () => setState(() {
                            offset + rows < powerZoneSchemas.length - rows
                                ? offset = offset + rows
                                : offset = powerZoneSchemas.length - rows;
                          }),
                ),
                const Spacer(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: templateButtons(),
            )
          ],
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              const Text('''
No power schema defined so far:
                
You can easily start with one of the three pre defined power schemas,
just click on one of the the buttons und go from there.

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
                          AddPowerZoneSchemaScreen(
                        powerZoneSchema:
                            PowerZoneSchema(athlete: widget.athlete),
                        numberOfSchemas: powerZoneSchemas.length,
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
    powerZoneSchemas = await athlete.powerZoneSchemas;
    if (widget.callBackFunction != null)
      await widget.callBackFunction();
    setState(() {});
  }

  Future<void> likeStryd() async {
    final Athlete athlete = widget.athlete;
    final PowerZoneSchema powerZoneSchema =
        PowerZoneSchema.likeStryd(athlete: athlete);
    await powerZoneSchema.save();
    await powerZoneSchema.addStrydZones();
    await getData();
  }

  Future<void> likeJimVance() async {
    final Athlete athlete = widget.athlete;
    final PowerZoneSchema powerZoneSchema =
        PowerZoneSchema.likeJimVance(athlete: athlete);
    await powerZoneSchema.save();
    await powerZoneSchema.addJimVanceZones();
    await getData();
  }

  Future<void> likeStefanDillinger() async {
    final Athlete athlete = widget.athlete;
    final PowerZoneSchema powerZoneSchema =
        PowerZoneSchema.likeStefanDillinger(athlete: athlete);
    await powerZoneSchema.save();
    await powerZoneSchema.addStefanDillingerZones();
    await getData();
  }

  Column templateButtons() {
    return Column(children: <Widget>[
      const Divider(),
      const Text('Add power zone schema from template:'),
      ElevatedButton(
        style: MyButtonStyle.raisedButtonStyle(color: Colors.orange),
        child: const Text('like Stryd'),
        onPressed: () => likeStryd(),
      ),
      ElevatedButton(
        style: MyButtonStyle.raisedButtonStyle(color: Colors.orange),
        child: const Text('like Jim Vance'),
        onPressed: () => likeJimVance(),
      ),
      ElevatedButton(
        style: MyButtonStyle.raisedButtonStyle(color: Colors.orange),
        child: const Text('like Stefan Dillinger'),
        onPressed: () => likeStefanDillinger(),
      ),
    ]);
  }
}
