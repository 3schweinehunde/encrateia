import 'package:encrateia/screens/add_tag_group_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AthleteTagGroupWidget extends StatefulWidget {
  final Athlete athlete;

  AthleteTagGroupWidget({this.athlete});

  @override
  _AthleteTagGroupWidgetState createState() => _AthleteTagGroupWidgetState();
}

class _AthleteTagGroupWidgetState extends State<AthleteTagGroupWidget> {
  List<TagGroup> tagGroups;
  int offset = 0;
  int rows;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(context) {
    if (tagGroups != null) {
      if (tagGroups.length > 0) {
        rows = (tagGroups.length < 8) ? tagGroups.length : 8;
        return ListView(
          children: <Widget>[
            Center(
              child: Text(
                "\nTag Groups ${offset + 1} - ${offset + rows} "
                "of ${tagGroups.length}",
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            DataTable(
              headingRowHeight: kMinInteractiveDimension * 0.80,
              dataRowHeight: kMinInteractiveDimension * 0.80,
              columnSpacing: 9,
              columns: <DataColumn>[
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Color")),
                DataColumn(label: Text("Edit")),
              ],
              rows: tagGroups
                  .sublist(offset, offset + rows)
                  .map((TagGroup tagGroup) {
                return DataRow(
                  key: Key(tagGroup.db.id.toString()),
                  cells: [
                    DataCell(Text(tagGroup.db.name)),
                    DataCell(CircleColor(
                      circleSize: 20,
                      elevation: 0,
                      color: Color(tagGroup.db.color),
                    )),
                    DataCell(
                      MyIcon.edit,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTagGroupScreen(
                              tagGroup: tagGroup,
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
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Spacer(),
                MyButton.add(
                    child: Text("New tag group"),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTagGroupScreen(
                            tagGroup: TagGroup(athlete: widget.athlete),
                          ),
                        ),
                      );
                      getData();
                    }),
                Spacer(),
                MyButton.navigate(
                  child: Text("<<"),
                  onPressed: (offset == 0)
                      ? null
                      : () => setState(() {
                            offset > 8 ? offset = offset - rows : offset = 0;
                          }),
                ),
                Spacer(),
                MyButton.navigate(
                  child: Text(">>"),
                  onPressed: (offset + rows == tagGroups.length)
                      ? null
                      : () => setState(() {
                            offset + rows < tagGroups.length - rows
                                ? offset = offset + rows
                                : offset = tagGroups.length - rows;
                          }),
                ),
                Spacer(),
              ],
            ),
          ],
        );
      } else {
        createDefaultTagGroups();
        return Center(
          child: Text("creating defaults ..."),
        );
      }
    } else {
      return Center(
        child: Text("loading"),
      );
    }
  }

  getData() async {
    Athlete athlete = widget.athlete;
    tagGroups = await athlete.tagGroups;
    setState(() {});
  }

  createDefaultTagGroups() async {
    await TagGroup.createDefaultTagGroups(athlete: widget.athlete);
    await getData();
    setState(() {});
  }
}
