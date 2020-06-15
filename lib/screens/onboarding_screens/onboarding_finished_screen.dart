import 'package:encrateia/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:encrateia/utils/icon_utils.dart';

class OnboardingFinishedScreen extends StatelessWidget {
  const OnboardingFinishedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.primary,
        title: const Text('Athlete created'),
      ),
      body: Card(
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
                FlatButton(
                  child: const Text('Finish'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
