import 'dart:ui';

import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/models/interval_tagging.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class IntervalTagWidget extends StatefulWidget {
  const IntervalTagWidget({
    @required this.interval,
    @required this.athlete,
  });

  final encrateia.Interval interval;
  final Athlete athlete;

  @override
  _IntervalTagWidgetState createState() => _IntervalTagWidgetState();
}

class _IntervalTagWidgetState extends State<IntervalTagWidget> {
  List<TagGroup> tagGroups;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didUpdateWidget(IntervalTagWidget oldWidget) {
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
                    isEnabled: tag.system != true,
                    label: Text(
                      tag.name,
                      style: TextStyle(
                        color: MyColor.textColor(
                          selected: tag.selected,
                          backgroundColor: Color(tag.color),
                        ),
                      ),
                    ),
                    avatar: CircleAvatar(
                      backgroundColor: Color(tag.color),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          IntervalTagging.createBy(
                              interval: widget.interval, tag: tag);
                        } else {
                          IntervalTagging.deleteBy(
                              interval: widget.interval, tag: tag);
                        }
                        tag.selected = selected;
                      });
                    },
                    selected: tag.selected,
                    selectedColor: Color(tag.color),
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
    tagGroups = await TagGroup.includingIntervalTaggings(
      athlete: widget.athlete,
      interval: widget.interval,
    );
    setState(() {});
  }
}
