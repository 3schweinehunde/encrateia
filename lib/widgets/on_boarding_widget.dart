import 'package:encrateia/models/power_zone_schema.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/strava_fit_download.dart';
import 'package:encrateia/utils/enums.dart';
import 'package:encrateia/screens/introduction_screen.dart';
import 'package:encrateia/screens/strava_get_user.dart';

class OnBoardingWidget extends StatefulWidget {
  const OnBoardingWidget(
      {Key key, @required this.athlete, @required this.initialStep})
      : super(key: key);

  final Athlete athlete;
  final OnBoardingStep initialStep;

  @override
  _OnBoardingWidgetState createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  Flushbar<Object> flushbar;
  OnBoardingStep currentStep;

  @override
  void initState() {
    currentStep = widget.initialStep;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case OnBoardingStep.introduction:
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: MyIcon.hello,
                title: const Text('Welcome!'),
                subtitle: const Text(
                  'Maybe you want to learn a bit about Encrateia before creating '
                  'your first user.\n'
                  'We have provided some introductory text for you.',
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                      child: const Text('Read Introduction'),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                              builder: (BuildContext _) => IntroductionScreen(),
                            ),
                          )),
                  FlatButton(
                      child: const Text('Continue'),
                      onPressed: () {
                        setState(() => currentStep = OnBoardingStep.createUser);
                      })
                ],
              ),
            ],
          ),
        );

      case OnBoardingStep.createUser:
        return ListView(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: MyIcon.create,
                    title: const Text('Option 1: Demo Athlete Setup'),
                    subtitle: const Text(
                        'Choose this option to create a demo user with demo setup.'
                        'This is the quickest option to explore Encrateia.'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Create Demo User'),
                        onPressed: () => demoUserSetup(),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: MyIcon.download,
                    title: const Text('Option 2: Athlete with Strava Account'),
                    subtitle: const Text(
                        'Choose this option, if you want to download activities '
                        'from Strava'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Connect to Strava'),
                        onPressed: () => stravaGetUser(context),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: MyIcon.upload,
                    title: const Text('Option 3: Standalone Athlete'),
                    subtitle: const Text(
                        'Choose this option, if you want to upload all'
                        ' .fit-files manually'),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Create standalone User'),
                        onPressed: () {
                          widget.athlete.setupStandaloneAthlete();
                          currentStep = OnBoardingStep.credentials;
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      case OnBoardingStep.finished:
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: MyIcon.hello,
                title: const Text('Congratulations!'),
                subtitle: const Text(
                  'You have successfully setup the athlete.',
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Finish'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ],
          ),
        );

      default:
        return Container();
    }
  }

  Future<void> saveStravaUser(BuildContext context) async {
    await widget.athlete.save();
    await widget.athlete.storeCredentials();
    flushbar = Flushbar<Object>(
      icon: MyIcon.information,
      message: 'checking credentials...',
      duration: const Duration(seconds: 10),
    )..show(context);
    if (await StravaFitDownload.credentialsAreValid(athlete: widget.athlete)) {
      flushbar.dismiss();
      Navigator.of(context).pop();
    } else
      flushbar = Flushbar<Object>(
        icon: MyIcon.error,
        message: 'The credentials provided are invalid!',
        duration: const Duration(seconds: 10),
      )..show(context);
  }

  Future<void> saveStandaloneUser(BuildContext context) async {
    widget.athlete.firstName =
        widget.athlete.firstName ?? widget.athlete.firstName;
    widget.athlete.lastName =
        widget.athlete.lastName ?? widget.athlete.lastName;
    await widget.athlete.save();
    setState(() => currentStep = OnBoardingStep.finished);
  }

  Future<void> stravaGetUser(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) =>
            StravaGetUser(athlete: widget.athlete),
      ),
    );
    setState(() => currentStep = OnBoardingStep.weight);
  }

  Future<void> demoUserSetup() async {
    final Athlete athlete = widget.athlete;
    athlete.firstName = athlete.firstName ?? athlete.firstName;
    widget.athlete.lastName =
        widget.athlete.lastName ?? widget.athlete.lastName;
    await widget.athlete.save();

    final PowerZoneSchema powerZoneSchema =
        PowerZoneSchema.likeStryd(athlete: widget.athlete);
    await powerZoneSchema.save();
    await powerZoneSchema.addStrydZones();

    setState(() => currentStep = OnBoardingStep.weight);
  }
}
