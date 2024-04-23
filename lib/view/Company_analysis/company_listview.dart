import 'package:flutter/material.dart';
import 'company_analysis_view_model.dart';

class company_listview extends StatefulWidget {
  const company_listview({Key? key}) : super(key: key);

  @override
  State<company_listview> createState() => _company_analysisState();
}

class _company_analysisState extends State<company_listview> {
  final companyheirarchy= CompanyHeirarchyViewModel();

  void initState() {

    super.initState();
  }
  bool showDateContainers = false;

  GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  DateTime? startDate;
  DateTime? endDate;
  List<String> concatenatedList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Company Analysis'),
        backgroundColor: Colors.green[800],
      ),
      body: Column());
  }
}
