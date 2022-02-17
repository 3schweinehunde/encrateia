import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/models/activity_tagging.dart';
import '/models/athlete.dart';
import '/models/tag.dart';
import '/models/tag_group.dart';
import '/utils/my_color.dart';

class ActivityTagWidget extends StatefulWidget {
  const ActivityTagWidget({Key? key,
    required this.activity,
    required this.athlete,
  }) : super(key: key);

  final Activity? activity;
  final Athlete? athlete;

  @override
  _ActivityTagWidgetState createState() => _ActivityTagWidgetState();
}

class _ActivityTagWidgetState extends State<ActivityTagWidget> {
  List<TagGroup>? tagGroups;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tagGroups == null) {
      return const Center(
        child: Text('Loading ...'),
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            childAspectRatio: 3),
        itemCount: tagGroups!.length,
        itemBuilder: (BuildContext context, int index) => Card(
          child: ListTile(
            title: Text(tagGroups![index].name! + '\n'),
            subtitle: Wrap(
              spacing: 15,
              children: <Widget>[
                for (Tag tag in tagGroups![index].cachedTags)
                  InputChip(
                    isEnabled: tag.system != true,
                    label: Text(
                      tag.name!,
                      style: TextStyle(
                        color: MyColor.textColor(
                          selected: tag.selected,
                          backgroundColor: Color(tag.color ?? 99999),
                        ),
                      ),
                    ),
                    avatar: CircleAvatar(
                      backgroundColor: Color(tag.color ?? 99999),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          ActivityTagging.createBy(
                            activity: widget.activity!,
                            tag: tag,
                          );
                        } else {
                          ActivityTagging.deleteBy(
                            activity: widget.activity!,
                            tag: tag,
                          );
                        }
                        tag.selected = selected;
                      });
                    },
                    selected: tag.selected,
                    selectedColor: Color(tag.color ?? 99999),
                    backgroundColor: MyColor.white,
                    elevation: 3,
                    padding: const EdgeInsets.all(10),
                  )
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> getData() async {
    tagGroups = await TagGroup.includingActivityTaggings(
      athlete: widget.athlete!,
      activity: widget.activity!,
    );
    setState(() {});
  }
}
