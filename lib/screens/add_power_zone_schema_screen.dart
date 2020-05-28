import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:encrateia/model/model.dart';
import 'add_power_zone_screen.dart';

class AddPowerZoneSchemaScreen extends StatefulWidget {
  const AddPowerZoneSchemaScreen({Key key, this.powerZoneSchema})
      : super(key: key);

  final PowerZoneSchema powerZoneSchema;

  @override
  _AddPowerZoneSchemaScreenState createState() =>
      _AddPowerZoneSchemaScreenState();
}

class _AddPowerZoneSchemaScreenState extends State<AddPowerZoneSchemaScreen> {
  List<PowerZone> powerZones = <PowerZone>[];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.settings,
        title: const Text('Add Power Zone Schema'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(40),
            child: ListTile(
              leading: MyIcon.warning,
              title:
                  const Text('Instructions to update your current base value'),
              subtitle: const Text(
                '1) Change the VALID FROM date to today to copy the power zone schema.\n'
                '2) Edit the BASE VALUE to the new value.\n'
                '3) Click SAVE to persist your changes.',
              ),
            ),
          ),
          DateTimeField(
            decoration: const InputDecoration(labelText: 'Valid from'),
            format: DateFormat('yyyy-MM-dd'),
            initialValue: widget.powerZoneSchema.db.date,
            onShowPicker: (BuildContext context, DateTime currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1969),
                initialDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
            },
            onChanged: (DateTime value) => copyPowerZoneSchema(date: value),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            initialValue: widget.powerZoneSchema.db.name,
            onChanged: (String value) => widget.powerZoneSchema.db.name = value,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Base value in W',
              helperText: 'e.g. Critical Power, Functional Threshold Power',
            ),
            initialValue: widget.powerZoneSchema.db.base.toString(),
            keyboardType: TextInputType.number,
            onChanged: (String value) =>
                updatePowerZoneBase(base: int.parse(value)),
          ),
          const SizedBox(height: 10),
          DataTable(
            headingRowHeight: kMinInteractiveDimension * 0.80,
            dataRowHeight: kMinInteractiveDimension * 0.75,
            columnSpacing: 20,
            horizontalMargin: 10,
            columns: const <DataColumn>[
              DataColumn(label: Text('Zone')),
              DataColumn(label: Text('Limits (W)')),
              DataColumn(label: Text('Color')),
              DataColumn(label: Text('Edit')),
            ],
            rows: powerZones.map((PowerZone powerZone) {
              return DataRow(
                key: ValueKey<int>(powerZone.db.id),
                cells: <DataCell>[
                  DataCell(Text(powerZone.db.name)),
                  DataCell(Text(powerZone.db.lowerLimit.toString() +
                      ' - ' +
                      powerZone.db.upperLimit.toString())),
                  DataCell(CircleColor(
                    circleSize: 20,
                    elevation: 0,
                    color: Color(powerZone.db.color),
                  )),
                  DataCell(
                    MyIcon.edit,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => AddPowerZoneScreen(
                            powerZone: powerZone,
                            base: widget.powerZoneSchema.db.base,
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.add(
                child: const Text('Add power zone'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) => AddPowerZoneScreen(
                        powerZone:
                            PowerZone(powerZoneSchema: widget.powerZoneSchema),
                        base: widget.powerZoneSchema.db.base,
                      ),
                    ),
                  );
                  getData();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(
                onPressed: () => deletePowerZoneSchema(
                  powerZoneSchema: widget.powerZoneSchema,
                ),
              ),
              const SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 5),
              MyButton.save(onPressed: () => savePowerZoneSchema(context)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> savePowerZoneSchema(BuildContext context) async {
    await widget.powerZoneSchema.db.save();
    await DbPowerZone()
        .upsertAll(powerZones.map((PowerZone powerZone) => powerZone.db).toList());
    Navigator.of(context).pop();
  }

  Future<void> getData() async {
    powerZones = await widget.powerZoneSchema.powerZones;
    setState(() {});
  }

  Future<void> deletePowerZoneSchema({PowerZoneSchema powerZoneSchema}) async {
    await powerZoneSchema.delete();
    Navigator.of(context).pop();
  }

  Future<void> updatePowerZoneBase({int base}) {
    setState(() {
      widget.powerZoneSchema.db.base = base;
      for (final PowerZone powerZone in powerZones) {
        powerZone.db.lowerLimit =
            (powerZone.db.lowerPercentage * base / 100).round();
        powerZone.db.upperLimit =
            (powerZone.db.upperPercentage * base / 100).round();
      }
    });
    return null;
  }

  Future<void> copyPowerZoneSchema({DateTime date}) async {
    widget.powerZoneSchema.db
      ..date = date
      ..id = null;
    final int powerZoneSchemaId = await widget.powerZoneSchema.db.save();
    for (final PowerZone powerZone in powerZones) {
      powerZone.db
        ..powerZoneSchemataId = powerZoneSchemaId
        ..id = null;
    }
    await DbPowerZone()
        .upsertAll(powerZones.map((PowerZone powerZone) => powerZone.db).toList());
    await getData();
    showDialog<BuildContext>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Power Zone Schema has been copied'),
        content: const Text(
            'If you only wanted to fix the date you need to delete the old '
            'power zone schema manually.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
