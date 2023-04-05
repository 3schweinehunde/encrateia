import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/models/power_zone_schema.dart';
import '/screens/onboarding_screens/onboarding_heart_rate_zone_schema_screen.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';
import '/widgets/athlete_widgets/athlete_power_zone_schema_widget.dart';

class OnBoardingPowerZoneSchemaScreen extends StatefulWidget {
  const OnBoardingPowerZoneSchemaScreen({
    Key? key,
    this.athlete,
  }) : super(key: key);

  final Athlete? athlete;

  @override
  OnBoardingPowerZoneSchemaScreenState createState() =>
      OnBoardingPowerZoneSchemaScreenState();
}

class OnBoardingPowerZoneSchemaScreenState
    extends State<OnBoardingPowerZoneSchemaScreen> {
  bool powerZoneSchemaHasBeenEntered = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyColor.athlete,
          title: const Text('Select a Power Zone Schema'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AthletePowerZoneSchemaWidget(
                athlete: widget.athlete,
                callBackFunction: getData,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child:
                    Text('You might want to check the base value for the Power '
                        'Zone Scheme before proceeding to the next step.'),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                MyButton.save(
                  onPressed: powerZoneSchemaHasBeenEntered ? nextButton : null,
                  child: const Text('Next step'),
                ),
                const SizedBox(width: 20),
              ]),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    final List<PowerZoneSchema> powerZoneSchemas =
        await widget.athlete!.powerZoneSchemas;
    setState(() => powerZoneSchemaHasBeenEntered = powerZoneSchemas.isNotEmpty);
  }

  Future<void> nextButton() async {
    await widget.athlete!.save();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext _) => OnBoardingHeartRateZoneSchemaScreen(
          athlete: widget.athlete,
        ),
      ),
    );
  }
}
