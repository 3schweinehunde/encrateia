import 'package:flutter/material.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button_style.dart';
import '/utils/my_color.dart';
import 'introduction_text_screen.dart';
import 'onboarding_create_user.dart';

class OnboardingIntroductionScreen extends StatelessWidget {
  const OnboardingIntroductionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future<bool>(() => false),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: const Text('Welcome to Encrateia!'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: MyIcon.hello,
                    title: const Text('Welcome!'),
                    subtitle: const Text(
                      'Maybe you want to learn a bit about Encrateia before creating '
                      'your first user.\n'
                      'We have provided some introductory text for you.',
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      ElevatedButton(
                        style: MyButtonStyle.raisedButtonStyle(
                            color: MyColor.primary),
                        child: const Text('Read Introduction'),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                            builder: (BuildContext _) =>
                                const IntroductionTextScreen(),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: MyButtonStyle.raisedButtonStyle(
                            color: MyColor.primary),
                        child: const Text('Continue'),
                        onPressed: () async {
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<BuildContext>(
                              builder: (BuildContext _) =>
                                  const OnboardingCreateUserScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
