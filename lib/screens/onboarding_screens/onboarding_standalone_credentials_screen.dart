import 'package:encrateia/utils/my_button.dart';
import 'package:encrateia/utils/my_color.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:encrateia/models/athlete.dart';
import 'onboarding_power_zone_schema_screen.dart';

class OnBoardingStandaloneCredentialsScreen extends StatefulWidget {
  const OnBoardingStandaloneCredentialsScreen({
    Key key,
    this.athlete,
  }) : super(key: key);

  final Athlete athlete;

  @override
  _OnBoardingStandaloneCredentialsScreenState createState() =>
      _OnBoardingStandaloneCredentialsScreenState();
}

class _OnBoardingStandaloneCredentialsScreenState
    extends State<OnBoardingStandaloneCredentialsScreen> {
  Flushbar<Object> flushbar = Flushbar<Object>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.athlete,
        title: const Text('Enter the Athlete\'s Name'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'First name'),
            initialValue: widget.athlete.firstName,
            onChanged: (String value) => widget.athlete.firstName = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Last name'),
            initialValue: widget.athlete.lastName,
            onChanged: (String value) => widget.athlete.lastName = value,
          ),

          // Cancel and Save Card
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MyButton.save(
                  onPressed: () async {
                    await widget.athlete.save();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<BuildContext>(
                        builder: (BuildContext _) =>
                            OnBoardingPowerZoneSchemaScreen(
                          athlete: widget.athlete,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
