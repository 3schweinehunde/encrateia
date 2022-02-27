import 'package:flutter/material.dart';

import '/models/athlete.dart';
import '/models/lap.dart';
import '/models/lap_tagging.dart';
import '/models/tag.dart';
import '/models/tag_group.dart';
import '/utils/my_color.dart';

class LapTagWidget extends StatefulWidget {
  const LapTagWidget({Key? key,
    required this.lap,
    required this.athlete,
  }) : super(key: key);

  final Lap? lap;
  final Athlete? athlete;

  @override
  _LapTagWidgetState createState() => _LapTagWidgetState();
}

class _LapTagWidgetState extends State<LapTagWidget> {
  List<TagGroup>? tagGroups;

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
                          backgroundColor: Color(tag.color!),
                        ),
                      ),
                    ),
                    avatar: CircleAvatar(
                      backgroundColor: Color(tag.color!),
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          LapTagging.createBy(lap: widget.lap!, tag: tag);
                        } else {
                          LapTagging.deleteBy(lap: widget.lap!, tag: tag);
                        }
                        tag.selected = selected;
                      });
                    },
                    selected: tag.selected,
                    selectedColor: Color(tag.color!),
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
    tagGroups = await TagGroup.includingLapTaggings(
      athlete: widget.athlete!,
      lap: widget.lap!,
    );
    setState(() {});
  }
}
