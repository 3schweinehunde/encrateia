import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';

class ShowAthleteDetailScreen extends StatelessWidget {
  const ShowAthleteDetailScreen({
    Key key,
    this.athlete,
    this.widget,
    this.title,
    this.backgroundColor,
  }) : super(key: key);

  final Athlete athlete;
  final Widget widget;
  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor ?? MyColor.athlete,
        title: Text(
          '$title: ${athlete.firstName} ${athlete.lastName}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(child: widget),
    );
  }
}
