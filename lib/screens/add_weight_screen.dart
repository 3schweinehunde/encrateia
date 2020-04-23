import 'package:encrateia/models/athlete.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/weight.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddWeightScreen extends StatelessWidget {
  final Athlete athlete;
  final Weight weight;

  const AddWeightScreen({
    Key key,
    this.athlete,
    this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    weight.db
      ..athletesId = athlete.db.id
      ..value = 70
      ..date = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add your Weight'),
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
            onChanged: (value) => weight.db.date = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Weight in kg"),
            initialValue: weight.db.value.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) => weight.db.value = double.parse(value),
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
                  onPressed: () => saveWeight(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  saveWeight(BuildContext context) async {
    await weight.db.save();
    Navigator.of(context).pop();
  }
}
