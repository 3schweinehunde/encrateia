import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/weight.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';

class AddWeightScreen extends StatelessWidget {
  const AddWeightScreen({Key? key, this.weight, required this.numberOfWeights})
      : super(key: key);

  final Weight? weight;
  final int numberOfWeights;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.settings,
        title: const Text('Add your Weight'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            DateTimeField(
              decoration: const InputDecoration(labelText: 'Date'),
              format: DateFormat('yyyy-MM-dd'),
              initialValue: weight!.date,
              onShowPicker: (BuildContext context, DateTime? currentValue) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime(1990),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100),
                );
              },
              onChanged: (DateTime? value) => weight!.date = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Weight in kg'),
              initialValue: weight!.value.toString(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (String value) => weight!.value = double.parse(value),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (numberOfWeights > 1)
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
      ),
    );
  }

  Future<void> saveWeight(BuildContext context) async {
    await weight!.save();
    Navigator.of(context).pop();
  }

  Future<void> deleteWeight(BuildContext context) async {
    await weight!.delete();
    Navigator.of(context).pop();
  }
}
