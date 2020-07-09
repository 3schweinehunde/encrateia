import 'package:encrateia/screens/onboarding_screens/onboarding_body_weight_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_heart_rate_zone_schema_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';

class OnBoardingHeartRateZoneSchemaScreen extends StatefulWidget {
  const OnBoardingHeartRateZoneSchemaScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _OnBoardingHeartRateZoneSchemaScreenState createState() =>
      _OnBoardingHeartRateZoneSchemaScreenState();
}

class _OnBoardingHeartRateZoneSchemaScreenState
    extends State<OnBoardingHeartRateZoneSchemaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColor.athlete,
        title: const Text('Select a Heart Rate Zone Schema'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: AthleteHeartRateZoneSchemaWidget(athlete: widget.athlete),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              MyButton.save(
                child: const Text('Next step'),
                onPressed: () async {
                  await widget.athlete.save();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext _) =>
                          OnBoardingBodyWeightScreen(
                        athlete: widget.athlete,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
            ]),
          ],
        ),
      ),
    );
  }
}
