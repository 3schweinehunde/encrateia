import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/widgets/activities_list_widget.dart';


class ListActivitiesScreen extends StatelessWidget {
  final Athlete athlete;

  const ListActivitiesScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: new ActivitiesListWidget(athlete: athlete,),
    );
  }
}
