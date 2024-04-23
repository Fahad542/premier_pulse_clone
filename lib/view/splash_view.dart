import 'package:flutter/material.dart';
import 'package:mvvm/view_model/services/splash_services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';


import '../model/version_model.dart';
import '../respository/version.dart';


class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}



class _SplashViewState extends State<SplashView> {

  SplashServices splashServices = SplashServices();
  bool _updateDialogShown = false;
  String localversion = '';
  String apiVersion = '';

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((packageInfo) {
      localversion = packageInfo.version;
      print('Local version: $version');

      final versionRepository = versionrespository();
      versionRepository.fetchVersion().then((version) {
        print(version.status); // Output: 200
        print(version.statusMessage); // Output: Version Fetch Successfully
        print(version.versionNo);
        setState(() {
          apiVersion = version.versionNo;

        });
        if (localversion == apiVersion) {
          splashServices.checkAuthentication(context); // Close the dialog only if the update was successful
        }else{
        showUpdateAlert(context);}
      }).catchError((error) {
        print(error);
      });
    });




  }

  void showUpdateAlert(BuildContext context) async {
    bool updateSuccessful = false; // Track whether the update was successful

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Override the back button behavior
            return false; // Return false to indicate that the back button press is handled manually
          },
          child: AlertDialog(
            title: Text('Update Available'),
            content: Text('A new version($apiVersion) of the app is available. And your current version is($localversion). Please update to the latest version.'),
            actions: [
              TextButton(
                onPressed: () async {
                  // Attempt to launch the Google Play Store URL
                  await launch('https://play.google.com/store/apps/details?id=com.premier.premierpulse');



                    Navigator.of(context).pop(); // Close the dialog only if the update was successful

                },
                child: Text('Update Now'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child:  Image.asset('assets/pulsenewicon.png', height: 280, width: 280,),

      )

    );
  }
}


class version extends StatelessWidget {
  const version({Key? key}) : super(key: key);

  static void showUpdateDialog(BuildContext context, String apiVersion, String localVersion) {
    bool updateSuccessful = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text('Update Available'),
            content: Text('A new version("$apiVersion") of the app is available. And your current version is("$localVersion"). Please update to the latest version.'),
            actions: [
              TextButton(
                onPressed: () async {
                  // Attempt to launch the Google Play Store URL
                  // await launch('https://play.google.com/store/apps/details?id=com.premier.superapp');



                    Navigator.of(context).pop(); // Close the dialog only if the update was successful



                },
                child: Text('Update Now'),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Container();
  }
}

