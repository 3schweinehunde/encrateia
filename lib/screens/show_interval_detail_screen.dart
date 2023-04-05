import 'package:flutter/material.dart';
import '/models/interval.dart' as encrateia;
import '/utils/my_color.dart';

class ShowIntervalDetailScreen extends StatefulWidget {
  const ShowIntervalDetailScreen({
    Key? key,
    required this.interval,
    required this.intervals,
    required this.nextWidget,
    required this.title,
  }) : super(key: key);

  final encrateia.Interval interval;
  final List<encrateia.Interval?> intervals;
  final Widget Function({encrateia.Interval? interval}) nextWidget;
  final String title;

  @override
  ShowIntervalDetailScreenState createState() =>
      ShowIntervalDetailScreenState();
}

class ShowIntervalDetailScreenState extends State<ShowIntervalDetailScreen> {
  encrateia.Interval? currentInterval;
  double dragAmount = 0;
  late int currentIntervalIndex;

  @override
  void initState() {
    currentInterval = widget.interval;
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.interval,
        title: Text(
          'Interval ${widget.intervals.length - currentIntervalIndex}: ${widget.title}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          child: widget.nextWidget(interval: currentInterval),
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            dragAmount = dragAmount + details.primaryDelta!;
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (dragAmount < -50) {
              dragAmount = 0;
              if (currentIntervalIndex > 0) {
                currentInterval = widget.intervals[currentIntervalIndex - 1];
                getData();
              }
            } else if (dragAmount > 50) {
              dragAmount = 0;
              if (currentIntervalIndex + 1 < widget.intervals.length) {
                currentInterval = widget.intervals[currentIntervalIndex + 1];
                getData();
              }
            }
          },
        ),
      ),
    );
  }

  void getData() {
    setState(
        () => currentIntervalIndex = widget.intervals.indexOf(currentInterval));
  }
}
