import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/models/heart_rate_zone_schema.dart';
import '/screens/onboarding_screens/onboarding_body_weight_screen.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';
import '/widgets/athlete_widgets/athlete_heart_rate_zone_schema_widget.dart';

class OnBoardingHeartRateZoneSchemaScreen extends StatefulWidget {
  const OnBoardingHeartRateZoneSchemaScreen({
    Key? key,
    this.athlete,
  }) : super(key: key);

  final Athlete? athlete;

  @override
  OnBoardingHeartRateZoneSchemaScreenState createState() =>
      OnBoardingHeartRateZoneSchemaScreenState();
}

class OnBoardingHeartRateZoneSchemaScreenState
    extends State<OnBoardingHeartRateZoneSchemaScreen> {
  bool heartRateZoneSchemaHasBeenEntered = false;

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
          title: const Text('Select a Heart Rate Zone Schema'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AthleteHeartRateZoneSchemaWidget(
                athlete: widget.athlete,
                callBackFunction: getData,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child:
                    Text('You might want to check the base value for the Heart '
                        'Rate Zone Scheme before proceeding to the next step.'),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                MyButton.save(
                  onPressed:
                      heartRateZoneSchemaHasBeenEntered ? nextButton : null,
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
    final List<HeartRateZoneSchema> heartRateZoneSchemas =
        await widget.athlete!.heartRateZoneSchemas;
    setState(() =>
        heartRateZoneSchemaHasBeenEntered = heartRateZoneSchemas.isNotEmpty);
  }

  Future<void> nextButton() async {
    await widget.athlete!.save();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext _) => OnBoardingBodyWeightScreen(
          athlete: widget.athlete,
        ),
      ),
    );
  }
}
