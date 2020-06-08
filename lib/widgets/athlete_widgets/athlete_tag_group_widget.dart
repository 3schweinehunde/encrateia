import 'package:encrateia/screens/add_tag_group_screen.dart';
import 'package:encrateia/screens/show_tag_group_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class AthleteTagGroupWidget extends StatefulWidget {
  const AthleteTagGroupWidget({this.athlete});

  final Athlete athlete;

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
  Widget build(BuildContext context) {
    if (tagGroups != null) {
      rows = (tagGroups.length < 8) ? tagGroups.length : 8;
      return ListView(
        children: <Widget>[
          Center(
            child: Text(
              '\nTag Groups ${offset + 1} - ${offset + rows} '
              'of ${tagGroups.length}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          DataTable(
            headingRowHeight: kMinInteractiveDimension * 0.80,
            dataRowHeight: kMinInteractiveDimension * 0.80,
            columnSpacing: 9,
            columns: const <DataColumn>[
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Color')),
              DataColumn(label: Text('Edit')),
            ],
            rows: tagGroups
                .sublist(offset, offset + rows)
                .map((TagGroup tagGroup) {
              return DataRow(
                key: ValueKey<int>(tagGroup.id),
                cells: <DataCell>[
                  DataCell(Text(tagGroup.name)),
                  DataCell(CircleColor(
                    circleSize: 20,
                    elevation: 0,
                    color: Color(tagGroup.color),
                  )),
                  DataCell(
                    tagGroup.system ? MyIcon.show : MyIcon.edit,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                          builder: (BuildContext context) {
                            if (tagGroup.system)
                              return ShowTagGroupScreen(tagGroup: tagGroup);
                            else
                              return AddTagGroupScreen(tagGroup: tagGroup);
                          },
                        ),
                      );
                      getData();
                    },
                  )
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              const Spacer(),
              MyButton.add(
                  child: const Text('New tag group'),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) => AddTagGroupScreen(
                          tagGroup: TagGroup(athlete: widget.athlete),
                        ),
                      ),
                    );
                    getData();
                  }),
              const Spacer(),
              MyButton.navigate(
                child: const Text('<<'),
                onPressed: (offset == 0)
                    ? null
                    : () => setState(() {
                          offset > 8 ? offset = offset - rows : offset = 0;
                        }),
              ),
              const Spacer(),
              MyButton.navigate(
                child: const Text('>>'),
                onPressed: (offset + rows == tagGroups.length)
                    ? null
                    : () => setState(() {
                          offset + rows < tagGroups.length - rows
                              ? offset = offset + rows
                              : offset = tagGroups.length - rows;
                        }),
              ),
              const Spacer(),
            ],
          ),
        ],
      );
    } else {
      return const Center(
        child: Text('loading'),
      );
    }
  }

  Future<void> getData() async {
    tagGroups = await widget.athlete.tagGroups;
    setState(() {});
  }
}
