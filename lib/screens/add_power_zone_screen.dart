import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '/models/power_zone.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';

class AddPowerZoneScreen extends StatefulWidget {
  const AddPowerZoneScreen(
      {Key? key, this.powerZone, this.base, required this.numberOfZones})
      : super(key: key);

  final PowerZone? powerZone;
  final int? base;
  final int numberOfZones;

  @override
  _AddPowerZoneScreenState createState() => _AddPowerZoneScreenState();
}

class _AddPowerZoneScreenState extends State<AddPowerZoneScreen> {
  void _openDialog(Widget content) {
    showDialog<BuildContext>(
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
                        widget.powerZone!.color = color.value,
                    selectedColor: Color(widget.powerZone!.color!));
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
        selectedColor: Color(widget.powerZone!.color!),
        onColorChange: (Color color) =>
            setState(() => widget.powerZone!.color = color.value),
        onBack: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController lowerLimitController =
        TextEditingController(text: widget.powerZone!.lowerLimit.toString());
    final TextEditingController upperLimitController =
        TextEditingController(text: widget.powerZone!.upperLimit.toString());
    final TextEditingController lowerPercentageController =
        TextEditingController(
            text: widget.powerZone!.lowerPercentage.toString());
    final TextEditingController upperPercentageController =
        TextEditingController(
            text: widget.powerZone!.upperPercentage.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your PowerZone'),
        backgroundColor: MyColor.settings,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              initialValue: widget.powerZone!.name,
              onChanged: (String value) => widget.powerZone!.name = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Lower Limit in W'),
              controller: lowerLimitController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                widget.powerZone!.lowerLimit = int.parse(value);
                widget.powerZone!.lowerPercentage =
                    (int.parse(value) * 100 / widget.base!).round();
                lowerPercentageController.text =
                    (int.parse(value) * 100 / widget.base!).round().toString();
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Upper Limit in W'),
              controller: upperLimitController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                widget.powerZone!.upperLimit = int.parse(value);
                widget.powerZone!.upperPercentage =
                    (int.parse(value) * 100 / widget.base!).round();
                upperPercentageController.text =
                    (int.parse(value) * 100 / widget.base!).round().toString();
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Lower Percentage in %'),
              controller: lowerPercentageController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                widget.powerZone!.lowerPercentage = int.parse(value);
                widget.powerZone!.lowerLimit =
                    (int.parse(value) * widget.base! / 100).round();
                lowerLimitController.text =
                    (int.parse(value) * widget.base! / 100).round().toString();
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Upper Percentage in %'),
              controller: upperPercentageController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                widget.powerZone!.upperPercentage = int.parse(value);
                widget.powerZone!.upperLimit =
                    (int.parse(value) * widget.base! / 100).round();
                upperLimitController.text =
                    (int.parse(value) * widget.base! / 100).round().toString();
              },
            ),
            const SizedBox(height: 10),
            Row(children: <Widget>[
              const Text('Color'),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Color(widget.powerZone!.color!),
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
                if (widget.numberOfZones > 1)
                  MyButton.delete(onPressed: () => deletePowerZone(context)),
                const SizedBox(width: 5),
                MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
                const SizedBox(width: 5),
                MyButton.save(onPressed: () => savePowerZone(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> savePowerZone(BuildContext context) async {
    await widget.powerZone!.save();
    Navigator.of(context).pop();
  }

  Future<void> deletePowerZone(BuildContext context) async {
    await widget.powerZone!.delete();
    Navigator.of(context).pop();
  }
}
