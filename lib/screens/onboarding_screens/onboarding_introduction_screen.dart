import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:encrateia/utils/icon_utils.dart';
import 'introduction_text_screen.dart';
import 'onboarding_create_user.dart';

class OnboardingIntroductionScreen extends StatelessWidget {
  const OnboardingIntroductionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primary,
        title: const Text('Welcome to Encrateia!'),
      ),
      body: Card(
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
                FlatButton(
                  child: const Text('Read Introduction'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext _) => IntroductionTextScreen(),
                    ),
                  ),
                ),
                FlatButton(
                  child: const Text('Continue'),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<BuildContext>(
                      builder: (BuildContext _) =>
                          const OnboardingCreateUserScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
