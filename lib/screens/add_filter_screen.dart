import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AddFilterScreen extends StatefulWidget {
  const AddFilterScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _AddFilterScreenState createState() => _AddFilterScreenState();
}

class _AddFilterScreenState extends State<AddFilterScreen> {
  List<TagGroup> tagGroups;

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
        title: const Text('Add Filter'),
      ),
      body: Column(
        children: <Widget>[
          const Card(
            child: ListTile(
              title: Text('Filter Logic'),
              subtitle:
                  Text('Tags within the same group are applied with an OR '
                      'operation, filters from different groups with an AND '
                      'operation.'),
            ),
          ),
          StaggeredGridView.countBuilder(
            shrinkWrap: true,
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            itemCount: tagGroups == null ? 0 : tagGroups.length,
            itemBuilder: (BuildContext context, int index) => Card(
              child: ListTile(
                title: Text(tagGroups[index].db.name + '\n'),
                subtitle: Wrap(
                  spacing: 15,
                  children: <Widget>[
                    for (Tag tag in tagGroups[index].cachedTags)
                      FilterChip(
                        label: Text(
                          tag.db.name,
                          style: TextStyle(
                            color: MyColor.textColor(
                              selected:
                                  widget.athlete.filters.contains(tag.db.id),
                              backgroundColor: Color(tag.db.color ?? 99999),
                            ),
                          ),
                        ),
                        avatar: CircleAvatar(
                          backgroundColor: Color(tag.db.color ?? 99999),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected)
                              widget.athlete.filters.add(tag.db.id);
                            else
                              widget.athlete.filters.removeWhere(
                                  (int tagId) => tagId == tag.db.id);
                          });
                        },
                        selected: widget.athlete.filters.contains(tag.db.id),
                        selectedColor: Color(tag.db.color ?? 99999),
                        backgroundColor: MyColor.white,
                        elevation: 3,
                        padding: const EdgeInsets.all(10),
                      )
                  ],
                ),
              ),
            ),
            staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            MyButton.save(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 20),
          ]),
        ],
      ),
    );
  }

  Future<void> getData() async {
    tagGroups = await TagGroup.all(athlete: widget.athlete);
    setState(() {});
  }
}
