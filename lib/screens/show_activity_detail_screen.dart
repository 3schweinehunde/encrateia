import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';

class ShowActivityDetailScreen extends StatelessWidget {
  const ShowActivityDetailScreen({
    Key key,
    this.activity,
    this.widget,
    this.title,
    this.backgroundColor,
  }) : super(key: key);

  final Activity activity;
  final Widget widget;
  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor ?? MyColor.activity,
        title: Text(
          '$title: ${activity.db.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: widget,
    );
  }
}
