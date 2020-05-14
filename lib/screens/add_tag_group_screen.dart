import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:encrateia/model/model.dart';
import 'add_tag_screen.dart';

class AddTagGroupScreen extends StatefulWidget {
  final TagGroup tagGroup;

  const AddTagGroupScreen({Key key, this.tagGroup}) : super(key: key);

  @override
  _AddTagGroupScreenState createState() => _AddTagGroupScreenState();
}

class _AddTagGroupScreenState extends State<AddTagGroupScreen> {
  List<Tag> tags = [];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

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
                        widget.tagGroup.db.color = color.value,
                    selectedColor: Color(widget.tagGroup.db.color));
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
        selectedColor: Color(widget.tagGroup.db.color),
        onColorChange: (color) =>
            setState(() => widget.tagGroup.db.color = color.value),
        onBack: () => {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.settings,
        title: Text('Add Tag Group'),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: "Name"),
            initialValue: widget.tagGroup.db.name,
            onChanged: (value) => widget.tagGroup.db.name = value,
          ),
          SizedBox(height: 20),
          Row(children: [
            Text("Color"),
            Spacer(),
            CircleAvatar(
              backgroundColor: Color(widget.tagGroup.db.color),
              radius: 20.0,
            ),
            Spacer(),
            MyButton.detail(
              onPressed: openColorPicker,
              child: Text('Edit'),
            ),
          ]),
          SizedBox(height: 20),
          DataTable(
            headingRowHeight: kMinInteractiveDimension * 0.80,
            dataRowHeight: kMinInteractiveDimension * 0.75,
            columnSpacing: 20,
            horizontalMargin: 10,
            columns: <DataColumn>[
              DataColumn(label: Text("Tag")),
              DataColumn(label: Text("Color")),
              DataColumn(label: Text("Edit")),
            ],
            rows: tags.map((Tag tag) {
              return DataRow(
                key: Key(tag.db.id.toString()),
                cells: [
                  DataCell(Text(tag.db.name)),
                  DataCell(CircleColor(
                    circleSize: 20,
                    elevation: 0,
                    color: Color(tag.db.color),
                  )),
                  DataCell(
                    MyIcon.edit,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTagScreen(
                            tag: tag,
                          ),
                        ),
                      );
                      getData();
                    },
                  )
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.add(
                child: Text("Add tag"),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTagScreen(
                        tag: Tag(tagGroup: widget.tagGroup),
                      ),
                    ),
                  );
                  getData();
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(
                onPressed: () => deleteTagGroup(
                  tagGroup: widget.tagGroup,
                ),
              ),
              SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              SizedBox(width: 5),
              MyButton.save(onPressed: () => saveTagGroup(context)),
            ],
          ),
        ],
      ),
    );
  }

  saveTagGroup(BuildContext context) async {
    await widget.tagGroup.db.save();
    await DbTag().upsertAll(tags.map((tag) => tag.db).toList());
    Navigator.of(context).pop();
  }

  getData() async {
    tags = await widget.tagGroup.tags;
    setState(() {});
  }

  deleteTagGroup({TagGroup tagGroup}) async {
    await tagGroup.delete();
    Navigator.of(context).pop();
  }
}
