import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '/models/tag.dart';
import '/models/tag_group.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';

class ShowTagGroupScreen extends StatefulWidget {
  const ShowTagGroupScreen({Key? key, this.tagGroup}) : super(key: key);

  final TagGroup? tagGroup;

  @override
  AddTagGroupScreenState createState() => AddTagGroupScreenState();
}

class AddTagGroupScreenState extends State<ShowTagGroupScreen> {
  List<Tag> tags = <Tag>[];
  int offset = 0;
  int? rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.settings,
        title: const Text('Show Tag Group'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              initialValue: widget.tagGroup!.name,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            Row(children: <Widget>[
              const Text('Color'),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Color(widget.tagGroup!.color!),
                radius: 20.0,
              ),
              const Spacer(),
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
              ],
              rows: tags.map((Tag tag) {
                return DataRow(
                  key: ValueKey<int?>(tag.id),
                  cells: <DataCell>[
                    DataCell(Text(tag.name!)),
                    DataCell(CircleColor(
                      circleSize: 20,
                      elevation: 0,
                      color: Color(tag.color!),
                    )),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 5),
                MyButton.cancel(onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    tags = await widget.tagGroup!.tags;
    setState(() {});
  }
}
