import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/power_zone.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddPowerZoneScreen extends StatefulWidget {
  const AddPowerZoneScreen({
    Key key,
    this.powerZone,
    this.base,
  }) : super(key: key);

  final PowerZone powerZone;
  final int base;

  @override
  _AddPowerZoneScreenState createState() => _AddPowerZoneScreenState();
}

class _AddPowerZoneScreenState extends State<AddPowerZoneScreen> {
  void _openDialog(Widget content) {
    showDialog<dynamic>(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: const Text('Select Color'),
          content: content,
          actions: <Widget>[
            MyButton.cancel(onPressed: Navigator.of(context).pop),
            MyButton.save(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop();
                MaterialColorPicker(
                    onColorChange: (Color color) =>
                        widget.powerZone.db.color = color.value,
                    selectedColor: Color(widget.powerZone.db.color));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> openColorPicker() async {
    _openDialog(
      MaterialColorPicker(
        selectedColor: Color(widget.powerZone.db.color),
        onColorChange: (Color color) => setState(() => widget.powerZone.db.color = color.value),
        onBack: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController lowerLimitController =
        TextEditingController(text: widget.powerZone.db.lowerLimit.toString());
    final TextEditingController upperLimitController =
        TextEditingController(text: widget.powerZone.db.upperLimit.toString());
    final TextEditingController lowerPercentageController = TextEditingController(
        text: widget.powerZone.db.lowerPercentage.toString());
    final TextEditingController upperPercentageController = TextEditingController(
        text: widget.powerZone.db.upperPercentage.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your PowerZone'),
        backgroundColor: MyColor.settings,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            initialValue: widget.powerZone.db.name,
            onChanged: (String value) => widget.powerZone.db.name = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Lower Limit in W'),
            controller: lowerLimitController,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              widget.powerZone.db.lowerLimit = int.parse(value);
              widget.powerZone.db.lowerPercentage =
                  (int.parse(value) * 100 / widget.base).round();
              lowerPercentageController.text =
                  (int.parse(value) * 100 / widget.base).round().toString();
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Upper Limit in W'),
            controller: upperLimitController,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              widget.powerZone.db.upperLimit = int.parse(value);
              widget.powerZone.db.upperPercentage =
                  (int.parse(value) * 100 / widget.base).round();
              upperPercentageController.text =
                  (int.parse(value) * 100 / widget.base).round().toString();
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Lower Percentage in %'),
            controller: lowerPercentageController,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              widget.powerZone.db.lowerPercentage = int.parse(value);
              widget.powerZone.db.lowerLimit =
                  (int.parse(value) * widget.base / 100).round();
              lowerLimitController.text =
                  (int.parse(value) * widget.base / 100).round().toString();
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Upper Percentage in %'),
            controller: upperPercentageController,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              widget.powerZone.db.upperPercentage = int.parse(value);
              widget.powerZone.db.upperLimit =
                  (int.parse(value) * widget.base / 100).round();
              upperLimitController.text =
                  (int.parse(value) * widget.base / 100).round().toString();
            },
          ),
          const SizedBox(height: 10),
          Row(children: <Widget>[
            const Text('Color'),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Color(widget.powerZone.db.color),
              radius: 20.0,
            ),
            const Spacer(),
            MyButton.detail(
              onPressed: openColorPicker,
              child: const Text('Edit'),
            ),
          ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(onPressed: () => deletePowerZone(context)),
              const SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 5),
              MyButton.save(onPressed: () => savePowerZone(context)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> savePowerZone(BuildContext context) async {
    await widget.powerZone.db.save();
    Navigator.of(context).pop();
  }

  Future<void> deletePowerZone(BuildContext context) async {
    await widget.powerZone.db.delete();
    Navigator.of(context).pop();
  }
}
