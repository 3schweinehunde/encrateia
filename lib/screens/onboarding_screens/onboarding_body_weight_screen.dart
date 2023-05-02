import 'package:flutter/material.dart';
import '/models/athlete.dart';
import '/models/weight.dart';
import '/screens/onboarding_screens/onboarding_finished_screen.dart';
import '/utils/my_button.dart';
import '/utils/my_color.dart';
import '/widgets/athlete_widgets/athlete_body_weight_widget.dart';

class OnBoardingBodyWeightScreen extends StatefulWidget {
  const OnBoardingBodyWeightScreen({
    Key? key,
    this.athlete,
  }) : super(key: key);

  final Athlete? athlete;

  @override
  OnBoardingBodyWeightScreenState createState() =>
      OnBoardingBodyWeightScreenState();
}

class OnBoardingBodyWeightScreenState
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
              AthleteBodyWeightWidget(
                athlete: widget.athlete,
                callBackFunction: getData,
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                MyButton.save(
                  onPressed: weightHasBeenEntered ? nextButton : null,
                  child: const Text('Next step'),
                ),
                const SizedBox(width: 20),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
    final List<Weight> weights = await widget.athlete!.weights;
    debugPrint(weights.length.toString());
    setState(() => weightHasBeenEntered = weights.isNotEmpty);
  }

  Future<void> nextButton() async {
    await widget.athlete!.save();
    debugPrint('OK');
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<BuildContext>(
          builder: (BuildContext _) => const OnboardingFinishedScreen(),
        ),
      );
    }
  }
}
