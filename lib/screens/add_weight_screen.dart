import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/weight.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddWeightScreen extends StatelessWidget {
  final Weight weight;

  const AddWeightScreen({
    Key key,
    this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            initialValue: weight.db.date,
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
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(
                onPressed: () => deleteWeight(context),
              ),
              SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              SizedBox(width: 5),
              MyButton.save(onPressed: () => saveWeight(context)),
            ],
          ),
        ],
      ),
    );
  }

  saveWeight(BuildContext context) async {
    await weight.db.save();
    Navigator.of(context).pop();
  }

  deleteWeight(BuildContext context) async {
    await weight.delete();
    Navigator.of(context).pop();
  }
}
