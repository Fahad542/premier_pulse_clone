

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/model/user_model.dart';
import 'package:mvvm/utils/routes/routes_name.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/Sales/Sales_viewmodel.dart';
import 'package:mvvm/view/login_view.dart';
import 'package:mvvm/view_model/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/auth_model.dart';
import '../../view/Attendance/Mark_Attandance/Mark Attendance_view.dart';

class SplashServices {


  Future<AuthModel> getUserDate() => UserViewModel().getUser();
SalesHeirarchyViewModel salesViewModel =SalesHeirarchyViewModel();

  void checkAuthentication(BuildContext context)async{

    getUserDate().then((value)async{
      final SharedPreferences sp = await SharedPreferences.getInstance();
     String lastSyncDate= sp.getString('lastSyncDate') ??'';
     //print(lastSyncDate);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username = prefs.getString('username') ?? '';
      String password = prefs.getString('password') ?? '';
      print('empCode: ${value.EmpCode.toString()}');
      print('empName: ${value.EmpName.toString()}');
      print('Designation: ${value.EmpDesignation.toString()}');
      print("Depth: ${value.Depth.toString()}");
      print('username: $username');
      print('password: $password');

      //print(lastSyncDate);
      await salesViewModel.initializeDatabase();
      if(lastSyncDate != DateFormat.yMd().format(DateTime.now()) )
      {salesViewModel.deletetable();}
      //print(currentdate.date);
      //currentdate.date;
      empcode.name=value.EmpName.toString();
      empcode.auth=value.EmpCode.toString();
      empcode.designation=value.EmpDesignation.toString();
      empcode.depth=value.Depth.toString();
      if(value.EmpCode.toString() == 'null' || value.EmpCode.toString() == ''){
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushNamed(context, RoutesName.login);
      }else {
        await Future.delayed(Duration(seconds: 3));
        await salesViewModel.initializeDatabase();
        final isTableEmpty = await salesViewModel.isDatabaseTableEmpty();
        if (!isTableEmpty) {
          Navigator.pushNamed(context, RoutesName.attandece);
        }
      else{
          Navigator.pushNamed(context, RoutesName.attandece);
          Utils.flushBarErrorMessage("Please Mark your Attendance", context);
        }
      }

    }).onError((error, stackTrace){
      if(kDebugMode){
        print(error.toString());
      }
    });

  }



}