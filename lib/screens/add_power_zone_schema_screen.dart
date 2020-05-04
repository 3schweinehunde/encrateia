import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:encrateia/model/model.dart';
import 'add_power_zone_screen.dart';

class AddPowerZoneSchemaScreen extends StatefulWidget {
  final PowerZoneSchema powerZoneSchema;

  const AddPowerZoneSchemaScreen({Key key, this.powerZoneSchema})
      : super(key: key);

  @override
  _AddPowerZoneSchemaScreenState createState() =>
      _AddPowerZoneSchemaScreenState();
}

class _AddPowerZoneSchemaScreenState extends State<AddPowerZoneSchemaScreen> {
  List<PowerZone> powerZones = [];
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
        title: Text('Add Power Zone Schema'),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20),
        children: <Widget>[
          DateTimeField(
            decoration: InputDecoration(
              labelText: "Valid from",
            ),
            format: DateFormat("yyyy-MM-dd"),
            initialValue: widget.powerZoneSchema.db.date,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1969),
                initialDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
            },
            onChanged: (value) => copyPowerZoneSchema(date: value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            initialValue: widget.powerZoneSchema.db.name,
            onChanged: (value) => widget.powerZoneSchema.db.name = value,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Base value in W",
              helperText: "e.g. Critical Power, Functional Threshold Power",
            ),
            initialValue: widget.powerZoneSchema.db.base.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => updatePowerZoneBase(base: int.parse(value)),
          ),
          SizedBox(height: 10),
          DataTable(
            headingRowHeight: kMinInteractiveDimension * 0.80,
            dataRowHeight: kMinInteractiveDimension * 0.75,
            columnSpacing: 20,
            horizontalMargin: 10,
            columns: <DataColumn>[
              DataColumn(label: Text("Zone")),
              DataColumn(label: Text("Limits (W)")),
              DataColumn(label: Text("Color")),
              DataColumn(label: Text("Edit")),
            ],
            rows: powerZones.map((PowerZone powerZone) {
              return DataRow(
                key: Key(powerZone.db.id.toString()),
                cells: [
                  DataCell(Text(powerZone.db.name)),
                  DataCell(Text(powerZone.db.lowerLimit.toString() +
                      " - " +
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
                        MaterialPageRoute(
                          builder: (context) => AddPowerZoneScreen(
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.add(
                child: Text("Add power zone"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPowerZoneScreen(
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(
                onPressed: () => deletePowerZoneSchema(
                  powerZoneSchema: widget.powerZoneSchema,
                ),
              ),
              SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              SizedBox(width: 5),
              MyButton.save(onPressed: () => savePowerZoneSchema(context)),
            ],
          ),
        ],
      ),
    );
  }

  savePowerZoneSchema(BuildContext context) async {
    await widget.powerZoneSchema.db.save();
    await DbPowerZone()
        .upsertAll(powerZones.map((powerZone) => powerZone.db).toList());
    Navigator.of(context).pop();
  }

  getData() async {
    powerZones = await widget.powerZoneSchema.powerZones;
    setState(() {});
  }

  deletePowerZoneSchema({PowerZoneSchema powerZoneSchema}) async {
    await powerZoneSchema.delete();
    Navigator.of(context).pop();
  }

  updatePowerZoneBase({int base}) {
    setState(() {
      widget.powerZoneSchema.db.base = base;
      for (PowerZone powerZone in powerZones) {
        powerZone.db.lowerLimit =
            (powerZone.db.lowerPercentage * base / 100).round();
        powerZone.db.upperLimit =
            (powerZone.db.upperPercentage * base / 100).round();
      }
    });
  }

  copyPowerZoneSchema({DateTime date}) async {
    widget.powerZoneSchema.db
      ..date = date
      ..id = null;
    int powerZoneSchemaId = await widget.powerZoneSchema.db.save();
    for (PowerZone powerZone in powerZones) {
      powerZone.db
        ..powerZoneSchemataId = powerZoneSchemaId
        ..id = null;
    }
    await DbPowerZone()
        .upsertAll(powerZones.map((powerZone) => powerZone.db).toList());
    await getData();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Power Zone Schema has been copied"),
        content: Text(
            "If you only wanted to fix the date you need to delete the old power zone schema manually."),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
