import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddTagScreen extends StatefulWidget {
  final Tag tag;
  final int base;

  const AddTagScreen({
    Key key,
    this.tag,
    this.base,
  }) : super(key: key);

  @override
  _AddTagScreenState createState() => _AddTagScreenState();
}

class _AddTagScreenState extends State<AddTagScreen> {
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
                    onColorChange: (color) => widget.tag.db.color = color.value,
                    selectedColor: Color(widget.tag.db.color));
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
        selectedColor: Color(widget.tag.db.color),
        onColorChange: (color) =>
            setState(() => widget.tag.db.color = color.value),
        onBack: () => {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your Tag'),
        backgroundColor: MyColor.settings,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            initialValue: widget.tag.db.name,
            onChanged: (value) => widget.tag.db.name = value,
          ),
          SizedBox(height: 10),
          Row(children: [
            Text("Color"),
            Spacer(),
            CircleAvatar(
              backgroundColor: Color(widget.tag.db.color),
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
              MyButton.delete(onPressed: () => deleteTag(context)),
              SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              SizedBox(width: 5),
              MyButton.save(onPressed: () => saveTag(context)),
            ],
          ),
        ],
      ),
    );
  }

  saveTag(BuildContext context) async {
    await widget.tag.db.save();
    Navigator.of(context).pop();
  }

  deleteTag(BuildContext context) async {
    await widget.tag.db.delete();
    Navigator.of(context).pop();
  }
}
