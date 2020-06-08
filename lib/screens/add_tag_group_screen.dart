import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/models/tag.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'add_tag_screen.dart';

class AddTagGroupScreen extends StatefulWidget {
  const AddTagGroupScreen({
    Key key,
    this.tagGroup,
  }) : super(key: key);

  final TagGroup tagGroup;

  @override
  _AddTagGroupScreenState createState() => _AddTagGroupScreenState();
}

class _AddTagGroupScreenState extends State<AddTagGroupScreen> {
  List<Tag> tags = <Tag>[];
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

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
                        widget.tagGroup.color = color.value,
                    selectedColor: Color(widget.tagGroup.color));
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
        selectedColor: Color(widget.tagGroup.color),
        onColorChange: (Color color) =>
            setState(() => widget.tagGroup.color = color.value),
        onBack: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.settings,
        title: const Text('Add Tag Group'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            initialValue: widget.tagGroup.name,
            onChanged: (String value) => widget.tagGroup.name = value,
          ),
          const SizedBox(height: 20),
          Row(children: <Widget>[
            const Text('Color'),
            const Spacer(),
            CircleAvatar(
              backgroundColor: Color(widget.tagGroup.color),
              radius: 20.0,
            ),
            const Spacer(),
            MyButton.detail(
              onPressed: openColorPicker,
              child: const Text('Edit'),
            ),
          ]),
          const SizedBox(height: 20),
          DataTable(
            headingRowHeight: kMinInteractiveDimension * 0.80,
            dataRowHeight: kMinInteractiveDimension * 0.75,
            columnSpacing: 20,
            horizontalMargin: 10,
            columns: const <DataColumn>[
              DataColumn(label: Text('Tag')),
              DataColumn(label: Text('Color')),
              DataColumn(label: Text('Edit')),
            ],
            rows: tags.map((Tag tag) {
              return DataRow(
                key: ValueKey<int>(tag.id),
                cells: <DataCell>[
                  DataCell(Text(tag.name)),
                  DataCell(CircleColor(
                    circleSize: 20,
                    elevation: 0,
                    color: Color(tag.color),
                  )),
                  DataCell(
                    MyIcon.edit,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) => AddTagScreen(
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.add(
                child: const Text('Add tag'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext context) => AddTagScreen(
                        tag: Tag.minimal(tagGroup: widget.tagGroup),
                      ),
                    ),
                  );
                  getData();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              MyButton.delete(
                onPressed: () => deleteTagGroup(
                  tagGroup: widget.tagGroup,
                ),
              ),
              const SizedBox(width: 5),
              MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 5),
              MyButton.save(onPressed: () => saveTagGroup(context)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveTagGroup(BuildContext context) async {
    await widget.tagGroup.save();
    await Tag().upsertAll(tags);
    Navigator.of(context).pop();
  }

  Future<void> getData() async {
    tags = await widget.tagGroup.tags;
    setState(() {});
  }

  Future<void> deleteTagGroup({TagGroup tagGroup}) async {
    await tagGroup.delete();
    Navigator.of(context).pop();
  }
}
