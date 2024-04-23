

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/data/local%20database/db_class.dart';
import 'package:mvvm/utils/routes/routes_name.dart';
import 'package:mvvm/view/Attendance/Attendance_report/sales.dart';
import 'package:mvvm/view/Attendance/Mark_Attandance/Mark%20Attendance_view.dart';
import 'package:mvvm/view/Home/home_screen.dart';
import 'package:mvvm/view/login_view.dart';
import 'package:mvvm/view/signp_view.dart';
import 'package:mvvm/view/splash_view.dart';

import '../../view/Attendance/Attendance_report/attendance_report_view.dart';
import '../../view/Company_analysis/compnay_analysis_view.dart';
import '../../view/Sales/Sales_view.dart';

class Routes {

  static Route<dynamic>  generateRoute(RouteSettings settings){

    switch(settings.name){
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => const SplashView());

      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen());

      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => const LoginView());
      case RoutesName.signUp:
        return MaterialPageRoute(builder: (BuildContext context) => const SignUpView());
      case RoutesName.attandece:
        return MaterialPageRoute(builder: (BuildContext context) => const Markattendance());
      // case RoutesName.attendancereport:
      //   return MaterialPageRoute(builder: (BuildContext context) =>  AttendanceReport());
      case RoutesName.sales:
        return MaterialPageRoute(builder: (BuildContext context) => SalesReport());
      case RoutesName.company_analysis:
        return MaterialPageRoute(builder: (BuildContext context) => company_analysis(name: '',));
      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });

    }
  }
}