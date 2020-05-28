import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/activity_widgets/activity_metadata_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_overview_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_ratio_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_speed_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_tag_widget.dart';
import 'package:encrateia/widgets/laps_list_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_ecor_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_duration_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_power_per_heart_rate_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_ground_time_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_leg_spring_stiffness_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_form_power_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_stryd_cadence_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_stride_ratio_widget.dart';
import 'package:encrateia/widgets/activity_widgets/activity_vertical_oscillation_widget.dart';
import 'package:encrateia/screens/show_activity_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/activity.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShowActivityScreen extends StatefulWidget {
  const ShowActivityScreen({
    Key key,
    @required this.activity,
    @required this.athlete,
  }) : super(key: key);

  final Activity activity;
  final Athlete athlete;

  @override
  _ShowActivityScreenState createState() => _ShowActivityScreenState();
}

class _ShowActivityScreenState extends State<ShowActivityScreen> {
  Flushbar<Object> flushbar = Flushbar<Object>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.activity,
        title: Text(
          widget.activity.db.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: StaggeredGridView.count(
        staggeredTiles:
            List<StaggeredTile>.filled(18, const StaggeredTile.fit(1)),
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(10),
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
        children: <Widget>[
          navigationButton(
            color: MyColor.settings,
            title: 'Overview',
            icon: MyIcon.overView,
            context: context,
            nextWidget: ActivityOverviewWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Laps List',
            color: MyColor.lap,
            backgroundColor: MyColor.lap,
            icon: MyIcon.laps,
            context: context,
            nextWidget: LapsListWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Heart Rate',
            color: MyColor.navigate,
            icon: MyIcon.heartRate,
            context: context,
            nextWidget: ActivityHeartRateWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Power',
            color: MyColor.navigate,
            icon: MyIcon.power,
            context: context,
            nextWidget: ActivityPowerWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Power\nDuration',
            color: MyColor.navigate,
            icon: MyIcon.powerDuration,
            context: context,
            nextWidget: ActivityPowerDurationWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Power /\nHeart Rate',
            color: MyColor.navigate,
            icon: MyIcon.power,
            context: context,
            nextWidget: ActivityPowerPerHeartRateWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Ecor',
            color: MyColor.navigate,
            icon: MyIcon.power,
            context: context,
            nextWidget: ActivityEcorWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Speed /\nHeart Rate',
            color: MyColor.navigate,
            icon: MyIcon.speed,
            context: context,
            nextWidget: ActivitySpeedPerHeartRateWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Ground Time',
            color: MyColor.navigate,
            icon: MyIcon.groundTime,
            context: context,
            nextWidget: ActivityGroundTimeWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Form Power',
            color: MyColor.navigate,
            icon: MyIcon.formPower,
            context: context,
            nextWidget: ActivityFormPowerWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Power Ratio',
            color: MyColor.navigate,
            icon: MyIcon.formPower,
            context: context,
            nextWidget: ActivityPowerRatioWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Vertical\nOscillation',
            color: MyColor.navigate,
            icon: MyIcon.verticalOscillation,
            context: context,
            nextWidget: ActivityVerticalOscillationWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Stride Ratio',
            color: MyColor.navigate,
            icon: MyIcon.strideRatio,
            context: context,
            nextWidget: ActivityStrideRatioWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Cadence',
            color: MyColor.navigate,
            icon: MyIcon.cadence,
            context: context,
            nextWidget: ActivityStrydCadenceWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Leg Spring\nStiffness',
            color: MyColor.navigate,
            icon: MyIcon.legSpringStiffness,
            context: context,
            nextWidget: ActivityLegSpringStiffnessWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Metadata',
            color: MyColor.settings,
            icon: MyIcon.metaData,
            context: context,
            nextWidget: ActivityMetadataWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          navigationButton(
            title: 'Tags',
            color: MyColor.tag,
            icon: MyIcon.tag,
            context: context,
            nextWidget: ActivityTagWidget(
              activity: widget.activity,
              athlete: widget.athlete,
            ),
          ),
          RaisedButton.icon(
            color: MyColor.add,
            icon: MyIcon.settings,
            textColor: MyColor.textColor(backgroundColor: MyColor.add),
            label: const Text('Rerun\n Autotagging'),
            onPressed: () => autoTagger(),
          ),
        ],
      ),
    );
  }

  Widget navigationButton({
    @required BuildContext context,
    @required Widget nextWidget,
    @required Widget icon,
    @required String title,
    @required Color color,
    Color backgroundColor,
  }) {
    return RaisedButton.icon(
      color: color,
      textColor: MyColor.textColor(backgroundColor: color),
      icon: icon,
      label: Text(title),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext context) => ShowActivityDetailScreen(
            activity: widget.activity,
            widget: nextWidget,
            title: title,
            backgroundColor: backgroundColor,
          ),
        ),
      ),
    );
  }

  Future<void> autoTagger() async {
    flushbar = Flushbar<Object>(
      message: 'Starting Autotagger',
      duration: const Duration(seconds: 10),
      icon: MyIcon.stravaDownloadWhite,
    )..show(context);

    await widget.activity.autoTagger(athlete: widget.athlete);

    flushbar.dismiss();
    flushbar = Flushbar<Object>(
      message: 'Autotagging finished',
      duration: const Duration(seconds: 2),
      icon: MyIcon.finishedWhite,
    )..show(context);
    setState(() {});
  }
}
