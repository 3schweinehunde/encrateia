import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AddTagScreen extends StatefulWidget {
  const AddTagScreen({
    Key key,
    this.tag,
    this.base,
  }) : super(key: key);

  final Tag tag;
  final int base;

  @override
  _AddTagScreenState createState() => _AddTagScreenState();
}

class _AddTagScreenState extends State<AddTagScreen> {
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
                    onColorChange: (Color color) => widget.tag.color = color.value,
                    selectedColor: Color(widget.tag.color));
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
        selectedColor: Color(widget.tag.color),
        onColorChange: (Color color) =>
            setState(() => widget.tag.color = color.value),
        onBack: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your Tag'),
        backgroundColor: MyColor.settings,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            initialValue: widget.tag.name,
            onChanged: (String value) => widget.tag.name = value,
          ),
          const SizedBox(height: 10),
          Row(children: <Widget>[
            const Text('Color'),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Color(widget.tag.color),
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
              MyButton.delete(onPressed: () => deleteTag(context)),
              const SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 5),
              MyButton.save(onPressed: () => saveTag(context)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveTag(BuildContext context) async {
    await widget.tag.save();
    Navigator.of(context).pop();
  }

  Future<void> deleteTag(BuildContext context) async {
    await widget.tag.delete();
    Navigator.of(context).pop();
  }
}
