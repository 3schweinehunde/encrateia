import 'package:encrateia/models/lap.dart';
import 'package:flutter/material.dart';

class ShowLapDetailScreen extends StatelessWidget {
  final Lap lap;
  final Widget widget;
  final String title;

  const ShowLapDetailScreen({
    Key key,
    @required this.lap,
    this.widget,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lap ${lap.index.toString()}: $title',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: widget,
    );
  }
}
