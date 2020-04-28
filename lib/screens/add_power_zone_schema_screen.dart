import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddPowerZoneSchemaScreen extends StatelessWidget {
  final Athlete athlete;
  final PowerZoneSchema powerZoneSchema;

  const AddPowerZoneSchemaScreen({
    Key key,
    this.athlete,
    this.powerZoneSchema,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    powerZoneSchema.db
      ..athletesId = athlete.db.id
      ..base = 250
      ..name = "MySchema"
      ..date = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add your PowerZoneSchema'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          DateTimeField(
            decoration: InputDecoration(labelText: "Date"),
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
            onChanged: (value) => powerZoneSchema.db.date = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "PowerZoneSchema in kg"),
            initialValue: powerZoneSchema.db.name,
            onChanged: (value) => powerZoneSchema.db.name = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "PowerZoneSchema in kg"),
            initialValue: powerZoneSchema.db.base.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => powerZoneSchema.db.base = int.parse(value),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Cancel', textScaleFactor: 1.5),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Container(width: 20.0),
                RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Save', textScaleFactor: 1.5),
                  onPressed: () => savePowerZoneSchema(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  savePowerZoneSchema(BuildContext context) async {
    await powerZoneSchema.db.save();
    Navigator.of(context).pop();
  }
}
