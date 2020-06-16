import 'package:encrateia/screens/onboarding_screens/onboarding_heart_rate_zone_schema_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_power_zone_schema_widget.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';

class OnBoardingPowerZoneSchemaScreen extends StatefulWidget {
  const OnBoardingPowerZoneSchemaScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _OnBoardingPowerZoneSchemaScreenState createState() =>
      _OnBoardingPowerZoneSchemaScreenState();
}

class _OnBoardingPowerZoneSchemaScreenState
    extends State<OnBoardingPowerZoneSchemaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColor.athlete,
        title: const Text('Select a Power Zone Schema'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: AthletePowerZoneSchemaWidget(athlete: widget.athlete),
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
                        OnBoardingHeartRateZoneSchemaScreen(
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
    );
  }
}
