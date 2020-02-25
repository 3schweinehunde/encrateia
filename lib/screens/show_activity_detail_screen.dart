import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class ShowActivityDetailScreen extends StatelessWidget {
  final Activity activity;
  final Widget widget;
  final String title;

  const ShowActivityDetailScreen({
    Key key,
    this.activity,
    this.widget,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$title: ${activity.db.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: widget,
    );
  }
}
