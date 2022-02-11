import 'package:flutter/material.dart';

import '/screens/dashboard.dart';
import '/utils/icon_utils.dart';
import '/utils/my_button_style.dart';
import '/utils/my_color.dart';

class OnboardingFinishedScreen extends StatelessWidget {
  const OnboardingFinishedScreen();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.primary,
          title: const Text('Athlete setup successfully'),
          automaticallyImplyLeading: false,
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
                    title: const Text('Congratulations!'),
                    subtitle: const Text(
                      'You have successfully setup the athlete.',
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      ElevatedButton(
                        style: MyButtonStyle.raisedButtonStyle(
                            color: MyColor.primary),
                        child: const Text('Finish'),
                        onPressed: () async {
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute<BuildContext>(
                              builder: (BuildContext _) => const Dashboard(),
                            ),
                            (_) => false,
                          );
                        },
                      )
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
