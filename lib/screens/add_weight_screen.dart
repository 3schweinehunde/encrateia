import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/weight.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class AddWeightScreen extends StatelessWidget {
  const AddWeightScreen({
    Key key,
    this.weight,
  }) : super(key: key);

  final Weight weight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.settings,
        title: const Text('Add your Weight'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          DateTimeField(
            decoration: const InputDecoration(labelText: 'Date'),
            format: DateFormat('yyyy-MM-dd'),
            initialValue: weight.db.date,
            onShowPicker: (BuildContext context, DateTime currentValue) {
              return showDatePicker(
                context: context,
                firstDate: DateTime(1990),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100),
              );
            },
            onChanged: (DateTime value) => weight.db.date = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Weight in kg'),
            initialValue: weight.db.value.toString(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (String value) => weight.db.value = double.parse(value),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(
                onPressed: () => deleteWeight(context),
              ),
              const SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 5),
              MyButton.save(onPressed: () => saveWeight(context)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveWeight(BuildContext context) async {
    await weight.db.save();
    Navigator.of(context).pop();
  }

  Future<void> deleteWeight(BuildContext context) async {
    await weight.delete();
    Navigator.of(context).pop();
  }
}
