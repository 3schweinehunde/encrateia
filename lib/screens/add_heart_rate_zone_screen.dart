import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddHeartRateZoneScreen extends StatefulWidget {
  const AddHeartRateZoneScreen({
    Key key,
    this.heartRateZone,
    this.base,
  }) : super(key: key);

  final HeartRateZone heartRateZone;
  final int base;

  @override
  _AddHeartRateZoneScreenState createState() => _AddHeartRateZoneScreenState();
}

class _AddHeartRateZoneScreenState extends State<AddHeartRateZoneScreen> {
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
                    widget.heartRateZone.db.color = color.value,
                    selectedColor: Color(widget.heartRateZone.db.color));
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
        selectedColor: Color(widget.heartRateZone.db.color),
        onColorChange: (Color color) => setState(() => widget.heartRateZone.db.color = color.value),
        onBack: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController lowerLimitController =
    TextEditingController(text: widget.heartRateZone.db.lowerLimit.toString());
    final TextEditingController upperLimitController =
    TextEditingController(text: widget.heartRateZone.db.upperLimit.toString());
    final TextEditingController lowerPercentageController = TextEditingController(
        text: widget.heartRateZone.db.lowerPercentage.toString());
    final TextEditingController upperPercentageController = TextEditingController(
        text: widget.heartRateZone.db.upperPercentage.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your HeartRateZone'),
        backgroundColor: MyColor.settings,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            initialValue: widget.heartRateZone.db.name,
            onChanged: (String value) => widget.heartRateZone.db.name = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Lower Limit in bpm'),
            controller: lowerLimitController,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              widget.heartRateZone.db.lowerLimit = int.parse(value);
              widget.heartRateZone.db.lowerPercentage =
                  (int.parse(value) * 100 / widget.base).round();
              lowerPercentageController.text =
                  (int.parse(value) * 100 / widget.base).round().toString();
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Upper Limit in bpm'),
            controller: upperLimitController,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              widget.heartRateZone.db.upperLimit = int.parse(value);
              widget.heartRateZone.db.upperPercentage =
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
              widget.heartRateZone.db.lowerPercentage = int.parse(value);
              widget.heartRateZone.db.lowerLimit =
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
              widget.heartRateZone.db.upperPercentage = int.parse(value);
              widget.heartRateZone.db.upperLimit =
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
              backgroundColor: Color(widget.heartRateZone.db.color),
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
              MyButton.delete(onPressed: () => deleteHeartRateZone(context)),
              const SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 5),
              MyButton.save(onPressed: () => saveHeartRateZone(context)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveHeartRateZone(BuildContext context) async {
    await widget.heartRateZone.db.save();
    Navigator.of(context).pop();
  }

  Future<void> deleteHeartRateZone(BuildContext context) async {
    await widget.heartRateZone.db.delete();
    Navigator.of(context).pop();
  }
}
