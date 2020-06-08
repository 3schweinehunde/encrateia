import 'dart:ui';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/activity_tagging.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ActivityTagWidget extends StatefulWidget {
  const ActivityTagWidget({
    @required this.activity,
    @required this.athlete,
  });

  final Activity activity;
  final Athlete athlete;

  @override
  _ActivityTagWidgetState createState() => _ActivityTagWidgetState();
}

class _ActivityTagWidgetState extends State<ActivityTagWidget> {
  List<TagGroup> tagGroups;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tagGroups == null)
      return const Center(
        child: Text('Loading ...'),
      );
    else
      return StaggeredGridView.countBuilder(
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
        itemCount: tagGroups.length,
        itemBuilder: (BuildContext context, int index) => Card(
          child: ListTile(
            title: Text(tagGroups[index].name + '\n'),
            subtitle: Wrap(
              spacing: 15,
              children: <Widget>[
                for (Tag tag in tagGroups[index].cachedTags)
                  InputChip(
                    isEnabled: tag.db.system != true,
                    label: Text(
                      tag.db.name,
                      style: TextStyle(
                        color: MyColor.textColor(
                          selected: tag.selected,
                          backgroundColor: Color(tag.db.color ?? 99999),
                        ),
                      ),
                    ),
                    avatar: CircleAvatar(
                      backgroundColor: Color(tag.db.color ?? 99999),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          ActivityTagging.createBy(
                            activity: widget.activity,
                            tag: tag,
                          );
                        } else {
                          ActivityTagging.deleteBy(
                            activity: widget.activity,
                            tag: tag,
                          );
                        }
                        tag.selected = selected;
                      });
                    },
                    selected: tag.selected,
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
      );
  }

  Future<void> getData() async {
    tagGroups = await TagGroup.includingActivityTaggings(
      athlete: widget.athlete,
      activity: widget.activity,
    );
    setState(() {});
  }
}
