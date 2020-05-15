import 'dart:ui';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/lap_tagging.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/lap.dart';

class LapTagWidget extends StatefulWidget {
  final Lap lap;
  final Athlete athlete;

  LapTagWidget({
    @required this.lap,
    @required this.athlete,
  });

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
  Widget build(context) {
    if (tagGroups == null)
      return Center(child: Text("Loading ..."));
    else
      return ListTileTheme(
        iconColor: MyColor.tag,
        child: ListView.builder(
          itemCount: tagGroups?.length ?? 0,
          itemBuilder: (context, index) {
            TagGroup tagGroup = tagGroups[index];
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(20),
                subtitle: Wrap(
                  spacing: 15,
                  children: [
                    for (Tag tag in tagGroup.cachedTags)
                      InputChip(
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
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              LapTagging.createBy(
                                lap: widget.lap,
                                tag: tag,
                              );
                            } else {
                              LapTagging.deleteBy(
                                lap: widget.lap,
                                tag: tag,
                              );
                            }
                            tag.selected = selected;
                          });
                        },
                        selected: tag.selected,
                        selectedColor: Color(tag.db.color),
                        backgroundColor: MyColor.white,
                        elevation: 3,
                        padding: EdgeInsets.all(10),
                      )
                  ],
                ),
                title: Text(tagGroup.db.name + "\n"),
              ),
            );
          },
        ),
      );
  }

  getData() async {
    tagGroups = await TagGroup.includingLapTaggings(
      athlete: widget.athlete,
      lap: widget.lap,
    );
    setState(() {});
  }
}
