import 'package:flutter/material.dart';

import '/models/activity.dart';
import '/utils/my_color.dart';

class ShowActivityDetailScreen extends StatelessWidget {
  const ShowActivityDetailScreen({
    Key? key,
    this.activity,
    this.widget,
    this.title,
    this.backgroundColor,
  }) : super(key: key);

  final Activity? activity;
  final Widget? widget;
  final String? title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor ?? MyColor.activity,
        title: Text(
          '$title: ${activity!.name}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(child: widget!),
    );
  }
}
