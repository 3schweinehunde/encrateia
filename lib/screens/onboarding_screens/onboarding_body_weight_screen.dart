import 'package:encrateia/screens/onboarding_screens/onboarding_finished_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_body_weight_widget.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_heart_rate_zone_schema_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';

class OnBoardingBodyWeightScreen extends StatefulWidget {
  const OnBoardingBodyWeightScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _OnBoardingBodyWeightScreenState createState() =>
      _OnBoardingBodyWeightScreenState();
}

class _OnBoardingBodyWeightScreenState
    extends State<OnBoardingBodyWeightScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColor.athlete,
        title: const Text('Enter your weight'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AthleteBodyWeightWidget(athlete: widget.athlete),
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
                        const OnboardingFinishedScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 20),
          ]),
        ],
      ),
    );
  }
}
