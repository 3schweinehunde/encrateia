import 'dart:ui';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/models/tag.dart';
import 'package:encrateia/models/activityTagging.dart';
import 'package:encrateia/models/tag_group.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class ActivityTagWidget extends StatefulWidget {
  final Activity activity;
  final Athlete athlete;

  ActivityTagWidget({
    @required this.activity,
    @required this.athlete,
  });

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
    tagGroups = await TagGroup.includingActivityTaggings(
      athlete: widget.athlete,
      activity: widget.activity,
    );
    setState(() {});
  }
}
