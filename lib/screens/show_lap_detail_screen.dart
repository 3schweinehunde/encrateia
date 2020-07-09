import 'package:encrateia/models/lap.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShowLapDetailScreen extends StatefulWidget {
  const ShowLapDetailScreen({
    Key key,
    @required this.lap,
    @required this.laps,
    @required this.nextWidget,
    @required this.title,
  }) : super(key: key);

  final Lap lap;
  final List<Lap> laps;
  final Widget Function({Lap lap}) nextWidget;
  final String title;

  @override
  _ShowLapDetailScreenState createState() => _ShowLapDetailScreenState();
}

class _ShowLapDetailScreenState extends State<ShowLapDetailScreen> {
  Lap currentLap;
  double dragAmount = 0;

  @override
  void initState() {
    currentLap = widget.lap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.lap,
        title: Text(
          'Lap ${currentLap.index.toString()}: ${widget.title}',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          child: widget.nextWidget(lap: currentLap),
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            dragAmount = dragAmount + details.primaryDelta;
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (dragAmount < -50) {
              dragAmount = 0;
              if (currentLap.index < widget.laps.length) {
                setState(() => currentLap = widget.laps[currentLap.index - 1 + 1]);
              }
            } else if (dragAmount > 50) {
              dragAmount = 0;
              if (currentLap.index > 1) {
                setState(
                    () => currentLap = widget.laps[currentLap.index - 1 - 1]);
              }
            }
          },
        ),
      ),
    );
  }
}
