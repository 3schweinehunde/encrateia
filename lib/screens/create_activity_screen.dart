import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/activity_widgets/edit_activity_widget.dart';
import 'package:flutter/material.dart';

class EditActivityScreen extends StatelessWidget {
  const EditActivityScreen({
    Key key,
    @required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.activity,
        title: const Text('Create Activity'),
      ),
      body: SafeArea(
        child: EditActivityWidget(activity: activity),
      ),
    );
  }
}
