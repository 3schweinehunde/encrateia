import 'package:encrateia/widgets/activity_metadata_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class ShowActivityScreen extends StatelessWidget {
  final Activity activity;

  const ShowActivityScreen({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${activity.db.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ActivityMetadataWidget(activity: activity),
    );
  }
}
