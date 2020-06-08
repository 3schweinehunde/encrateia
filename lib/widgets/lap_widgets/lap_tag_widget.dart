import 'dart:ui';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/lap_tagging.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LapTagWidget extends StatefulWidget {
  const LapTagWidget({
    @required this.lap,
    @required this.athlete,
  });

  final Lap lap;
  final Athlete athlete;

  @override
  _LapTagWidgetState createState() => _LapTagWidgetState();
}

class _LapTagWidgetState extends State<LapTagWidget> {
  List<TagGroup> tagGroups;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(LapTagWidget oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
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
                          backgroundColor: Color(tag.db.color),
                        ),
                      ),
                    ),
                    avatar: CircleAvatar(
                      backgroundColor: Color(tag.db.color),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          LapTagging.createBy(lap: widget.lap, tag: tag);
                        } else {
                          LapTagging.deleteBy(lap: widget.lap, tag: tag);
                        }
                        tag.selected = selected;
                      });
                    },
                    selected: tag.selected,
                    selectedColor: Color(tag.db.color),
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
    tagGroups = await TagGroup.includingLapTaggings(
      athlete: widget.athlete,
      lap: widget.lap,
    );
    setState(() {});
  }
}
