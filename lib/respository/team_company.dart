import 'dart:convert';

import 'package:mvvm/model/team_company.dart';
import 'package:mvvm/view/login_view.dart';
import '../model/company_execution_model.dart';
import 'api_services.dart';

class team_company_Repository {

  final PostApiService _apiService = PostApiService();
  Future<List> team_company_fetchData(String startdate, String enddate, String status,List<String> measures) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }

    final url = 'https://api.psplbi.com/api/hclassmeasure';
    print(url);
    final requestData =
    [

      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "ColumnName": "Company",
        "ClassName": [status],
        "MeasureName":[...measures,"Sales Inc ST"]


      }
    ];
    print(jsonEncode(requestData));

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}


class team_company_Repository_all {

  final PostApiService _apiService = PostApiService();
  Future<List> team_company_fetchData(String startdate, String enddate,String name,List<String> measures) async {
    for (int i = 0; i < measures.length; i++) {
      if (measures[i] == "Sales Inc ST") {
        measures.removeAt(i);
        break; // Exit the loop after removing the value
      }
    }
    final url = 'https://api.psplbi.com/api/hclassmeasure';
    print(url);
    final requestData =
    [
      {
        "FirstDate": startdate,
        "LastDate": enddate,
        "ColumnName": name,
      "MeasureName":[...measures,"Sales Inc ST"]

      }
    ];
    print(requestData);

    var response = await _apiService.postData1(url, requestData);
    print("api data: $response");
    return response;
  }
}







