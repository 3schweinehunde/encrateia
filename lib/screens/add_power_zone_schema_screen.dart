import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

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
    var db = widget.powerZoneSchema.db;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Power Zone Schema'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          DateTimeField(
            decoration: InputDecoration(
              labelText: "Valid from",
            ),
            format: DateFormat("yyyy-MM-dd"),
            initialValue: DateTime.now(),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1990),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
              );
            },
            onChanged: (value) => db.date = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            initialValue: db.name,
            onChanged: (value) => db.name = value,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Base value in W",
              helperText: "e.g. Critical Power, Functional Threshold Power",
            ),
            initialValue: db.base.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => db.base = int.parse(value),
          ),
          Divider(),
          Text(
            "Zones",
            style: Theme.of(context).textTheme.title,
          ),
          DataTable(
            dataRowHeight: kMinInteractiveDimension * 0.75,
            columnSpacing: 1,
            horizontalMargin: 12,
            columns: <DataColumn>[
              DataColumn(label: Text("Name")),
              DataColumn(
                label: Text("Limits (W)"),
                numeric: true,
              ),
              DataColumn(
                label: Text("Color"),
                numeric: true,
              ),
              DataColumn(label: Text("")),
              DataColumn(label: Text("")),
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
                    MyIcon.delete,
                    onTap: () => deletePowerZone(powerZone: powerZone),
                  ),
                  DataCell(
                    MyIcon.edit,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPowerZoneScreen(
                          powerZone: powerZone,
                        ),
                      ),
                    ).then((_) => getData()()),
                  )
                ],
              );
            }).toList(),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              RaisedButton(
                color: Colors.green,
                child: Text("Add power zone"),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPowerZoneScreen(
                      powerZone:
                          PowerZone(powerZoneSchema: widget.powerZoneSchema),
                    ),
                  ),
                ).then((_) => getData()()),
              ),
              Spacer(flex: 10),
            ],
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Spacer(flex: 10),
                RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Delete', textScaleFactor: 1.5),
                  onPressed: () => deletePowerZoneSchema(
                  powerZoneSchema: widget.powerZoneSchema, ),
                ),
                Spacer(),
                RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Cancel', textScaleFactor: 1.5),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Spacer(),
                RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Save', textScaleFactor: 1.5),
                  onPressed: () => savePowerZoneSchema(context),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  savePowerZoneSchema(BuildContext context) async {
    await widget.powerZoneSchema.db.save();
    Navigator.of(context).pop();
  }

  getData() async {
    powerZones = await widget.powerZoneSchema.powerZones;
    setState(() {});
  }

  deletePowerZone({PowerZone powerZone}) async {
    await powerZone.db.delete();
    await getData();
  }

  deletePowerZoneSchema({PowerZoneSchema powerZoneSchema}) async {
    await powerZoneSchema.delete();
    Navigator.of(context).pop();
  }
}
