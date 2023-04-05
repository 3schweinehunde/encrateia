import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '/models/heart_rate_zone.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';

class AddHeartRateZoneScreen extends StatefulWidget {
  const AddHeartRateZoneScreen(
      {Key? key, this.heartRateZone, this.base, required this.numberOfZones})
      : super(key: key);

  final HeartRateZone? heartRateZone;
  final int? base;
  final int numberOfZones;

  @override
  AddHeartRateZoneScreenState createState() => AddHeartRateZoneScreenState();
}

class AddHeartRateZoneScreenState extends State<AddHeartRateZoneScreen> {
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
                        widget.heartRateZone!.color = color.value,
                    selectedColor: Color(widget.heartRateZone!.color!));
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
        selectedColor: Color(widget.heartRateZone!.color!),
        onColorChange: (Color color) =>
            setState(() => widget.heartRateZone!.color = color.value),
        onBack: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController lowerLimitController = TextEditingController(
        text: widget.heartRateZone!.lowerLimit.toString());
    final TextEditingController upperLimitController = TextEditingController(
        text: widget.heartRateZone!.upperLimit.toString());
    final TextEditingController lowerPercentageController =
        TextEditingController(
            text: widget.heartRateZone!.lowerPercentage.toString());
    final TextEditingController upperPercentageController =
        TextEditingController(
            text: widget.heartRateZone!.upperPercentage.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your HeartRateZone'),
        backgroundColor: MyColor.settings,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              initialValue: widget.heartRateZone!.name,
              onChanged: (String value) => widget.heartRateZone!.name = value,
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Lower Limit in bpm'),
              controller: lowerLimitController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                widget.heartRateZone!.lowerLimit = int.parse(value);
                widget.heartRateZone!.lowerPercentage =
                    (int.parse(value) * 100 / widget.base!).round();
                lowerPercentageController.text =
                    (int.parse(value) * 100 / widget.base!).round().toString();
              },
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Upper Limit in bpm'),
              controller: upperLimitController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                widget.heartRateZone!.upperLimit = int.parse(value);
                widget.heartRateZone!.upperPercentage =
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
                widget.heartRateZone!.lowerPercentage = int.parse(value);
                widget.heartRateZone!.lowerLimit =
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
                widget.heartRateZone!.upperPercentage = int.parse(value);
                widget.heartRateZone!.upperLimit =
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
                backgroundColor: Color(widget.heartRateZone!.color!),
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
                  MyButton.delete(
                      onPressed: () => deleteHeartRateZone(context)),
                const SizedBox(width: 5),
                MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
                const SizedBox(width: 5),
                MyButton.save(onPressed: () => saveHeartRateZone(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveHeartRateZone(BuildContext context) async {
    await widget.heartRateZone!.save();
    Navigator.of(context).pop();
  }

  Future<void> deleteHeartRateZone(BuildContext context) async {
    await widget.heartRateZone!.delete();
    Navigator.of(context).pop();
  }
}
