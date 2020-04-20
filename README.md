# encrateia

tl;dr: Activity tracker data analysis app for Android and iOS

If you want to get back all your running, cycling, ... tracking data and analyse 
it yourself, this app could be interesting for you one day. Currently, we are in 
the beta stage. 

There is a [marketing site for Encrateia](https://encrateia.informatom.com), 
which gives all the details about downloading, compatibility, the team and 
lots of screenshots.

## License

Encrateia is [GPL v3](LICENSE) licensed and will always stay open source 
software. Future versions in app/play stores will not be for free, but you will 
always be able to get the source code and build it yourself.  

## Instructions for Self-Compiling

If you want to compile Encrateia yourself, this is the way to go:

* First you need to have [Flutter](https://flutter.dev/docs/get-started/install) 
(and Dart) installed for your operating system.

* If you want to have Strava integration, i.e. downloads working, you need to get
  your own app token from Strava, because it's your app then. All
  the responsibilities using Strava's API are on your side then.
  See Strava's 
  [Authorization Documentation](https://developers.strava.com/docs/authentication/)
  for details and how to request access.

* You then need to create a file `secrets.dart` within `/lib/secrets/` and enter
  your secret and client id:
  ```
  final String secret = "my_token_which_is_a_long_hex_string";
  final String clientId = "my_client_id_which_is_a_five_digit_integer";
  ```

* If you don't care about Strava integration, you'll still need that file,
  just put in some dummy data for secret and client id:
  ```
  final String secret = "a1b2c3d4e5f6";
  final String clientId = "12345";
  ```
  Obviously, downloads from Strava won't work then.

* I always forget how to split into apks by architecture, when compiling.
  This is, how it's done: `flutter build apk --split-per-abi`
