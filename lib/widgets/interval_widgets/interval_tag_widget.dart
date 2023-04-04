import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/models/interval.dart' as encrateia;
import '/models/interval_tagging.dart';
import '/models/tag.dart';
import '/models/tag_group.dart';
import '/utils/my_color.dart';

class IntervalTagWidget extends StatefulWidget {
  const IntervalTagWidget({
    Key? key,
    required this.interval,
    required this.athlete,
  }) : super(key: key);

  final encrateia.Interval? interval;
  final Athlete? athlete;

  @override
  IntervalTagWidgetState createState() => IntervalTagWidgetState();
}

class IntervalTagWidgetState extends State<IntervalTagWidget> {
  List<TagGroup>? tagGroups;

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
                          IntervalTagging.createBy(
                              interval: widget.interval!, tag: tag);
                        } else {
                          IntervalTagging.deleteBy(
                              interval: widget.interval!, tag: tag);
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
    tagGroups = await TagGroup.includingIntervalTaggings(
      athlete: widget.athlete!,
      interval: widget.interval!,
    );
    setState(() {});
  }
}
