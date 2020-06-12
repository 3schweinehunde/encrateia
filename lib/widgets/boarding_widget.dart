import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/edit_athlete_screen.dart';
import 'package:encrateia/screens/introduction_screen.dart';

class BoardingWidget extends StatefulWidget {
  const BoardingWidget({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _BoardingWidgetState createState() => _BoardingWidgetState();
}

class _BoardingWidgetState extends State<BoardingWidget> {
  @override
  Widget build(BuildContext context) {
    return Stepper(steps: );
  }
}
