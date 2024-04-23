import 'dart:ffi';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/view/Home/home_screen.dart';
import 'package:mvvm/view/splash_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../res/color.dart';
import '../../../utils/Drawer.dart';
import '../../../utils/homeappbar.dart';
import '../../../utils/utils.dart';
import '../../Sales/Sales_viewmodel.dart';

class Markattendance extends StatefulWidget {
  const Markattendance({Key? key}) : super(key: key);

  @override
  State<Markattendance> createState() => _MarkattendanceState();
}

class _MarkattendanceState extends State<Markattendance> {
  String currentTime='';
  //String? result;
  String lastSyncDate='';
  double latitude=0.0;
  double longitude=0.0;
  bool isLocationPermissionGranted = false;
  void get() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    lastSyncDate= sp.getString('lastSyncDate') ??'';
    currentTime= sp.getString('currentTime')?? '';
    latitude= sp.getDouble('latitude') ?? 0.0;
    longitude=sp.getDouble('longitude') ?? 0.0;
    setState(() {});
  }

  void delete() async {
    await salesViewModel.initializeDatabase();
    if(lastSyncDate != DateFormat.yMd().format(DateTime.now()) )
    {salesViewModel.deletetable();}
  }
  void geo(Double lat , Double long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  @override
  void initState() {
      get();
      delete();
      version v =version();
      super.initState();

  }



  GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  HomeScreen home=HomeScreen();


  String currentTimeString='';
  // Initialize the view model
  final salesViewModel = SalesHeirarchyViewModel();
String emp="";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      scaffoldKey1.currentState?.openDrawer();
      // Return false to prevent the default behavior of popping the current route
      return false;
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey1,
      appBar: GeneralAppBar(
        title: "Mark Attendance",
        ontapmenu: () {
          scaffoldKey1.currentState?.openDrawer();
        },

      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [



            GestureDetector(
                onTap: () async {
                  var connectivityResult = await Connectivity().checkConnectivity();
                  if (connectivityResult == ConnectivityResult.none) {
                    // No internet connection, show a toast or any other indication
                    Fluttertoast.showToast(
                      msg: "No Internet Connection",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                       var permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse && latitude=='' && longitude=='') {

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Location Permission Required'),
                            content: Text('Please enable location access in your device settings to use this feature.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Open device settings here using platform-specific code.
                                  // You can use packages like `app_settings` for this purpose.
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }


                  await salesViewModel.initializeDatabase();
                  bool isTableEmpty = await salesViewModel.isDatabaseTableEmpty();

                  if (!isTableEmpty) {
                    // Show a toast indicating that attendance is already marked
                    Fluttertoast.showToast(
                      msg: "Attendance is already marked",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: AppColors.ligthgreen,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }

                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.best,
                  );

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.transparent,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.greencolor),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Please wait...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  try {

                    await salesViewModel.initializeDatabase();
                    await salesViewModel.fetchHeirarchyListApi();
                    await salesViewModel.fetchTeamCompanyApi();
                    await salesViewModel.fetchbranchapi();
                    await salesViewModel.initializeDatabase();
                    final isTableEmpty = await salesViewModel.isDatabaseTableEmpty();
                    if(!isTableEmpty){
                      setState(() {
                        lastSyncDate = DateFormat.yMd().format(DateTime.now());
                        currentTime = DateFormat.jm().format(DateTime.now());
                        latitude = position.latitude;
                        longitude = position.longitude;
                      });
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      await prefs.setString('lastSyncDate', lastSyncDate!);
                      await prefs.setString('currentTime', currentTime!);
                      SharedPreferences pref = await SharedPreferences.getInstance();    // await pref.setDouble('latitude', latitude);
                      await pref.setDouble('longitude', longitude);
                      await pref.setDouble('latitude', latitude);
                      currentdate.date=lastSyncDate;
                      print(currentdate.date);
                      Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: AppColors.greencolor,
                          title: Text(
                            "Attendance Marked",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            "Your attendance has been marked.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                FocusScope.of(context).unfocus();
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );}
                    else{
                      Utils.flushBarErrorMessage("Error to load data", context);
                    }
                  } catch (error) {

                    Navigator.of(context).pop();

                    // Show an error dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: Colors.red,
                            title: Text(
                              "Error",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              "An error occurred while marking attendance.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();

                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),


                              )]);
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),

                  ),
                  child: Column(
                    children: [
                      Text("Mark Attendance", style: TextStyle(color: AppColors.greencolor, fontSize: 20, fontWeight: FontWeight.w500)),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(120),
                        child: Image.asset('assets/500-fingerprint-security-outline.gif', height: 250,),
                      ),

                    ],
                  ),
                )

            ),
            SizedBox(height: 20), // Added spacing below the "Mark Attendance" button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    print(lastSyncDate);
                  },
                  child: IconText(
                    iconData: Icons.calendar_today,
                    text: lastSyncDate,
                  ),
                ),
                InkWell(
                  onTap: (){
                    //print(currentdate.date);
                  },
                  child: IconText(
                    iconData: Icons.access_time,
                    text:currentTime
                    ,
                  ),
                ),
                InkWell(
                  onTap: (){
                    print("Latitude: $latitude, Longitude: $longitude");
                  },
                  child: IconText(
                    iconData: Icons.location_on,
                    text:   "$latitude\n$longitude",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class IconText extends StatelessWidget {
  final IconData iconData;
  final String text;

  IconText({required this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(

          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color:  AppColors.greencolor,borderRadius: BorderRadius.circular(16)


          ),

          child: Icon(
            iconData,
            size: 40,
            color: AppColors.whiteColor
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.greencolor
          ),
        ),
      ],
    );
  }
}

class currentdate {
  static String? date;


  static void updated_date(String update) {
    date = update;
  }

}