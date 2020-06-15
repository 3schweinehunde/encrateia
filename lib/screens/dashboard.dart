import 'package:encrateia/screens/onboarding_screens/onboarding_create_user.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:encrateia/models/athlete.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'onboarding_screens/onboarding_introduction_screen.dart';
import 'show_athlete_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Athlete> athletes = <Athlete>[];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (athletes.isEmpty)
      return Container();
    else
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: const Text('Encrateia Dashboard'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            for (Athlete athlete in athletes)
              Card(
                child: ListTile(
                  leading: athlete.photoPath != null
                      ? Image.network(athlete.photoPath)
                      : MyIcon.runningBig,
                  title: Text('${athlete.firstName} ${athlete.lastName}'),
                  onTap: () async {
                    await athlete.readCredentials();
                    await Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) =>
                            ShowAthleteScreen(athlete: athlete),
                      ),
                    );
                    getData();
                  },
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: MyColor.add,
          label: const Text('Add Athlete'),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<BuildContext>(
                builder: (BuildContext context) => const OnboardingCreateUserScreen(
                ),
              ),
            );
            getData();
          },
        ),
      );
  }

  Future<void> getData() async {
    athletes = await Athlete.all();
    if(athletes.isEmpty)
      Navigator.push(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext context) =>
            const OnboardingIntroductionScreen(),
      ),
    );
    setState(() {});
  }
}
