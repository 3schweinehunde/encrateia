import 'package:encrateia/models/interval.dart' as encrateia;
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShowIntervalDetailScreen extends StatefulWidget {
  const ShowIntervalDetailScreen({
    Key key,
    @required this.interval,
    @required this.intervals,
    @required this.nextWidget,
    @required this.title,
  }) : super(key: key);

  final encrateia.Interval interval;
  final List<encrateia.Interval> intervals;
  final Widget Function({encrateia.Interval interval}) nextWidget;
  final String title;

  @override
  _ShowIntervalDetailScreenState createState() => _ShowIntervalDetailScreenState();
}

class _ShowIntervalDetailScreenState extends State<ShowIntervalDetailScreen> {
  encrateia.Interval currentInterval;
  double dragAmount = 0;

  @override
  void initState() {
    currentInterval = widget.interval;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.interval,
        title: Text(
          'Interval ${currentInterval.index.toString()}: ${widget.title}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          child: widget.nextWidget(interval: currentInterval),
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            dragAmount = dragAmount + details.primaryDelta;
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (dragAmount < -50) {
              dragAmount = 0;
              if (currentInterval.index < widget.intervals.length) {
                setState(() => currentInterval = widget.intervals[currentInterval.index - 1 + 1]);
              }
            } else if (dragAmount > 50) {
              dragAmount = 0;
              if (currentInterval.index > 1) {
                setState(
                        () => currentInterval = widget.intervals[currentInterval.index - 1 - 1]);
              }
            }
          },
        ),
      ),
    );
  }
}
