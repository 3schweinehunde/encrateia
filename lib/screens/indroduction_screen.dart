import 'package:flutter/material.dart';

class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Introduction")),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('''
Encrateia is an mobile application that wants to help you analyse your activity tracking data. In particular Encrateia analyzes .fit-Files that are created by many fitness trackers by default.

Encrateia is quite a sophisticated piece of software with 20+ charts, and 10+ reports, so we thought, we'd share the rationale behind Encrateia and what it actually does:

A lot of runners and cyclists upload their activity data to Strava, to be able to share and analyse and because storage capacity on tracking devices is limited. Old tracking data is typically deleted without asking the user for consent.

We want to provide a possibility for you to get all your fitness data back and because you already own a smart phone and tablet we went the route to create this app.

Encrateia helps you download your original tracking data - the .fit-files from Strava, also for activities, that are no longer on your tracker.

To get your data, we fetch information about your actitvities via the Strava API. You have to authorize the Encrateia app to do so. As the .fit-files can only be downloaded from the web site (and not via the API) you have to provide your Strava credentials a second time.

Then you can use the [Download from Strava]-Button on the Athlete Screen to download the latest of your actitvties. They are stored on your device (and you could create a backup manually, if you like).
Then the .fit-files are parsed and the data is stored in a local SQLite database on the device. This takes quite some time, parsing is quick, but storing is 20 to 30 seconds per activtity.
That makes later analysis a lot quicker and it has only to be done once.

No data is leaving your device, neither to the developer of Encrateia, nor to any third party service. We believe, your activity data should be stricty yours.

Encrateia is, while not for free, an open source application. The source code can be retrieved from GitHub at: https://github.com/3schweinehunde/encrateia
The .fit-file parser is a seperate library, you can find it at: https://github.com/3schweinehunde/fit_parser 

If you have any questions regarding Encrateia, feel free to write an email to the main developer Stefan Haslinger using <stefan@3-schweinehun.de>

But now: Have fun analyzing your data and always keep running, cycling or whatever your favourite sports are!
              '''),
          ),
        ),
      ),
    );
  }
}
