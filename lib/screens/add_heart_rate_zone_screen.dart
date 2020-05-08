import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/heart_rate_zone.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddHeartRateZoneScreen extends StatefulWidget {
  final HeartRateZone heartRateZone;
  final int base;

  const AddHeartRateZoneScreen({
    Key key,
    this.heartRateZone,
    this.base,
  }) : super(key: key);

  @override
  _AddHeartRateZoneScreenState createState() => _AddHeartRateZoneScreenState();
}

class _AddHeartRateZoneScreenState extends State<AddHeartRateZoneScreen> {
  void _openDialog(Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text("Select Color"),
          content: content,
          actions: [
            MyButton.cancel(onPressed: Navigator.of(context).pop),
            MyButton.save(
              child: Text('Select'),
              onPressed: () {
                Navigator.of(context).pop();
                MaterialColorPicker(
                    onColorChange: (color) =>
                    widget.heartRateZone.db.color = color.value,
                    selectedColor: Color(widget.heartRateZone.db.color));
              },
            ),
          ],
        );
      },
    );
  }

  void openColorPicker() async {
    _openDialog(
      MaterialColorPicker(
        selectedColor: Color(widget.heartRateZone.db.color),
        onColorChange: (color) => setState(() => widget.heartRateZone.db.color = color.value),
        onBack: () => {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lowerLimitController =
    TextEditingController(text: widget.heartRateZone.db.lowerLimit.toString());
    var upperLimitController =
    TextEditingController(text: widget.heartRateZone.db.upperLimit.toString());
    var lowerPercentageController = TextEditingController(
        text: widget.heartRateZone.db.lowerPercentage.toString());
    var upperPercentageController = TextEditingController(
        text: widget.heartRateZone.db.upperPercentage.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Add your HeartRateZone'),
        backgroundColor: MyColor.settings,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            initialValue: widget.heartRateZone.db.name,
            onChanged: (value) => widget.heartRateZone.db.name = value,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Lower Limit in bpm"),
            controller: lowerLimitController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              widget.heartRateZone.db.lowerLimit = int.parse(value);
              widget.heartRateZone.db.lowerPercentage =
                  (int.parse(value) * 100 / widget.base).round();
              lowerPercentageController.text =
                  (int.parse(value) * 100 / widget.base).round().toString();
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Upper Limit in bpm"),
            controller: upperLimitController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              widget.heartRateZone.db.upperLimit = int.parse(value);
              widget.heartRateZone.db.upperPercentage =
                  (int.parse(value) * 100 / widget.base).round();
              upperPercentageController.text =
                  (int.parse(value) * 100 / widget.base).round().toString();
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Lower Percentage in %"),
            controller: lowerPercentageController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              widget.heartRateZone.db.lowerPercentage = int.parse(value);
              widget.heartRateZone.db.lowerLimit =
                  (int.parse(value) * widget.base / 100).round();
              lowerLimitController.text =
                  (int.parse(value) * widget.base / 100).round().toString();
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Upper Percentage in %"),
            controller: upperPercentageController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              widget.heartRateZone.db.upperPercentage = int.parse(value);
              widget.heartRateZone.db.upperLimit =
                  (int.parse(value) * widget.base / 100).round();
              upperLimitController.text =
                  (int.parse(value) * widget.base / 100).round().toString();
            },
          ),
          SizedBox(height: 10),
          Row(children: [
            Text("Color"),
            Spacer(),
            CircleAvatar(
              backgroundColor: Color(widget.heartRateZone.db.color),
              radius: 20.0,
            ),
            Spacer(),
            MyButton.detail(
              onPressed: openColorPicker,
              child: Text('Edit'),
            ),
          ]),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(onPressed: () => deleteHeartRateZone(context)),
              SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              SizedBox(width: 5),
              MyButton.save(onPressed: () => saveHeartRateZone(context)),
            ],
          ),
        ],
      ),
    );
  }

  saveHeartRateZone(BuildContext context) async {
    await widget.heartRateZone.db.save();
    Navigator.of(context).pop();
  }

  deleteHeartRateZone(BuildContext context) async {
    await widget.heartRateZone.db.delete();
    Navigator.of(context).pop();
  }
}
