import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/models/tag.dart';
import '/models/tag_group.dart';
import '/utils/my_color.dart';

class AthleteCurrentFilterWidget extends StatelessWidget {
  const AthleteCurrentFilterWidget({
    Key? key,
    required this.athlete,
    required this.tagGroups,
  }) : super(key: key);

  final Athlete? athlete;
  final List<TagGroup> tagGroups;

  @override
  Widget build(BuildContext context) {
    bool empty;

    if (athlete!.filters.isNotEmpty) {
      final List<Widget> widgets = <Widget>[];
      widgets.add(const Text('Current Filter: '));
      for (final TagGroup tagGroup in tagGroups) {
        empty = true;
        for (final Tag tag in tagGroup.cachedTags) {
          if (athlete!.filters.contains(tag.id)) {
            if (empty == true) {
              widgets.add(const Text('('));
              widgets.add(Text(' ${tagGroup.name}: '));
              empty = false;
            } else {
              widgets.add(const Text('OR'));
            }
            widgets.add(
              Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.fromLTRB(4, -6, 4, -6),
                labelPadding: const EdgeInsets.fromLTRB(0, -6, 0, -6),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1))),
                label: Text(
                  tag.name!,
                  style: TextStyle(
                    color: MyColor.textColor(
                      selected: true,
                      backgroundColor: Color(tag.color ?? 99999),
                    ),
                  ),
                ),
                backgroundColor: Color(tag.color ?? 99999),
                elevation: 3,
              ),
            );
          }
        }
        if (empty == false) {
          empty = true;
          widgets.add(const Text(')'));
          if (tagGroup != tagGroups.last) {
            widgets.add(const Text('AND'));
          }
        }
      }

      return Wrap(
        spacing: 5,
        runSpacing: 15,
        children: widgets,
      );
    } else {
      return Container();
    }
  }
}
