import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import '/models/athlete.dart';
import '/models/log.dart';
import '/screens/log_list_screen.dart';
import '/screens/onboarding_screens/onboarding_create_user.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';
import 'onboarding_screens/onboarding_introduction_screen.dart';
import 'show_athlete_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<Athlete> athletes = <Athlete>[];
  List<Log> logs = <Log>[];
  String? version;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (athletes.isEmpty) {
      return Container();
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          automaticallyImplyLeading: false,
          title: const Text('Encrateia Dashboard'),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              for (Athlete athlete in athletes)
                Card(
                  child: ListTile(
                    leading: athlete.photoPath != null
                        ? Image.network(athlete.photoPath!)
                        : MyIcon.runningBig,
                    title: Text('${athlete.firstName} ${athlete.lastName}'),
                    onTap: () async {
                      await athlete.readCredentials();
                      if (context.mounted) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) =>
                                ShowAthleteScreen(athlete: athlete),
                          ),
                        );
                      }
                      await getData();
                    },
                  ),
                ),
              const SizedBox(height: 20),
              if (version != null)
                Text(
                  'Encrateia version $version',
                  style: const TextStyle(fontSize: 12),
                ),
              if (logs.isNotEmpty)
                MyButton.log(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext context) =>
                            const LogListScreen(),
                      ),
                    );
                    await getData();
                  },
                )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: MyColor.add,
          label: const Text('Add Athlete'),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<BuildContext>(
                builder: (BuildContext context) =>
                    const OnboardingCreateUserScreen(),
              ),
            );
            await getData();
          },
        ),
      );
    }
  }

  Future<void> getData() async {
    athletes = await Athlete.all();
    logs = await Log.one();
    if (athletes.isEmpty) {
      if (context.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<BuildContext>(
            builder: (BuildContext context) =>
            const OnboardingIntroductionScreen(),
          ),
        );
      }
    } else {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
      setState(() {});
    }
  }
}
