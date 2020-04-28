import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/power_zone.dart';

class AddPowerZoneScreen extends StatelessWidget {
  final Athlete athlete;
  final PowerZone powerZone;

  const AddPowerZoneScreen({
    Key key,
    this.athlete,
    this.powerZone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    powerZone.db
      ..powerZoneSchemataId = powerZone.db.id
      ..lowerLimit = 70
      ..upperLimit = 100
      ..color = 0xFFFFc107;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add your PowerZone'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            initialValue: powerZone.db.name,
            onChanged: (value) => powerZone.db.name = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Lower Limit in W"),
            initialValue: powerZone.db.lowerLimit.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => powerZone.db.lowerLimit = int.parse(value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Upper Limit in W"),
            initialValue: powerZone.db.upperLimit.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => powerZone.db.upperLimit = int.parse(value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Lower Percentage in %"),
            initialValue: powerZone.db.lowerPercentage.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => powerZone.db.lowerPercentage = int.parse(value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Upper Percentage in %"),
            initialValue: powerZone.db.upperPercentage.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => powerZone.db.upperPercentage = int.parse(value),
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
                  onPressed: () => savePowerZone(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  savePowerZone(BuildContext context) async {
    await powerZone.db.save();
    Navigator.of(context).pop();
  }
}
