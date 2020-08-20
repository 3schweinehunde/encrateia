import 'package:encrateia/models/weight.dart';
import 'package:encrateia/screens/onboarding_screens/onboarding_finished_screen.dart';
import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:encrateia/widgets/athlete_widgets/athlete_body_weight_widget.dart';
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
  bool weightHasBeenEntered = false;

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
          title: const Text('Enter your weight'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              AthleteBodyWeightWidget(athlete: widget.athlete, callBackFunction: getData),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                MyButton.save(
                  child: const Text('Next step'),
                  onPressed: weightHasBeenEntered ? nextButton : null,
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
    final List<Weight> weights = await widget.athlete.weights;
    print(weights.length);
    setState(() => weightHasBeenEntered = weights.isNotEmpty);
  }

  Future<void> nextButton() async {
    await widget.athlete.save();
    print('OK');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<BuildContext>(
        builder: (BuildContext _) => const OnboardingFinishedScreen(),
      ),
    );
  }
}
