import 'package:encrateia/models/heart_rate_zone_schema.dart';
import 'package:encrateia/models/power_zone_schema.dart';
import 'package:encrateia/models/weight.dart';
import 'package:encrateia/screens/onboarding_screens/onboarding_finished_screen.dart';
import 'package:encrateia/screens/onboarding_screens/onboarding_strava_credentials_screen.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/screens/strava_get_user.dart';

class OnboardingCreateUserScreen extends StatefulWidget {
  const OnboardingCreateUserScreen();

  @override
  _OnboardingCreateUserScreenState createState() =>
      _OnboardingCreateUserScreenState();
}

class _OnboardingCreateUserScreenState
    extends State<OnboardingCreateUserScreen> {
  Athlete athlete = Athlete();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: const Text('Creating an Athlete'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
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
                          onPressed: () async {
                            await demoAthleteSetup();
                            MaterialPageRoute<BuildContext>(
                              builder: (BuildContext _) =>
                                  const OnboardingFinishedScreen(),
                            );
                          },
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
                      title:
                          const Text('Option 2: Athlete with Strava Account'),
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
                            athlete.setupStandaloneAthlete();
                            MaterialPageRoute<BuildContext>(
                              builder: (BuildContext _) =>
                                  OnBoardingStravaCredentialsScreen(
                                      athlete: athlete),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> demoAthleteSetup() async {
    final Athlete athlete = Athlete();
    await athlete.setupStandaloneAthlete();

    final PowerZoneSchema powerZoneSchema =
        PowerZoneSchema.likeStryd(athlete: athlete);
    await powerZoneSchema.save();
    await powerZoneSchema.addStrydZones();

    final HeartRateZoneSchema heartRateZoneSchema =
        HeartRateZoneSchema.likeGarmin(athlete: athlete);
    await heartRateZoneSchema.save();
    await heartRateZoneSchema.addGarminZones();

    final Weight weight = Weight(athlete: athlete);
    weight.date = DateTime(2015);
    await weight.save();


  }

  Future<void> stravaGetUser(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) => StravaGetUser(athlete: athlete),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext _) =>
            OnBoardingStravaCredentialsScreen(athlete: athlete),
      ),
    );
  }
}
