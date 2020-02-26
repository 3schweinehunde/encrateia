import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';

class ShowAthleteDetailScreen extends StatelessWidget {
  final Athlete athlete;
  final Widget widget;
  final String title;

  const ShowAthleteDetailScreen({
    Key key,
    this.athlete,
    this.widget,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$title: ${athlete.db.firstName} ${athlete.db.lastName}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: widget,
    );
  }
}
