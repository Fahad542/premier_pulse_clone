

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/model/get_channels_model.dart';
import 'package:mvvm/res/components/round_button.dart';
import 'package:mvvm/respository/category_repository.dart';
import 'package:mvvm/respository/get_branches_repositiory.dart';
import 'package:mvvm/respository/sku_repository.dart';
import 'package:mvvm/respository/sub_category_repository.dart';
import 'package:mvvm/respository/team_company.dart';
import 'package:mvvm/utils/app_colors.dart';
import 'package:mvvm/utils/customs_widgets/calculated_sale.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/login_view.dart';
import 'package:share/share.dart';
import '../../model/category_model.dart';
import '../../model/get_bracnhes_model.dart';
import '../../respository/Division_repository.dart';
import '../../respository/get_channel_repository.dart';
import '../../respository/measure_repository.dart';
import '../../utils/customs_widgets/circle_avatar_index.dart';
import '../../utils/customs_widgets/list_filters.dart';
import '../../utils/customs_widgets/text_widget.dart';
import '../Sales/Date.dart';
import '../Sales/Sales_viewmodel.dart';
import 'company_analysis_view_model.dart';

class company_analysis extends StatefulWidget {
  final String name;
   DateTime? startdate;
  DateTime? enddate;
   company_analysis({Key? key, required this.name ,  this.startdate, this.enddate
  }) : super(key: key);


  @override
  State<company_analysis> createState() => _company_analysisState();
}

class _company_analysisState extends State<company_analysis> {
  var team;
  var division;
  var filterlist;

  List<get_bracnhes_model> branches = [];
  List<get_channels_model> channel = [];
  var skumodel = [];
  String companyid='';
  String categoryid='';
  String sub_categoryid='';
  String brandid='';
  String productid='';
  String companyname='';
  String categoryname='';
  String sub_categoryname='';
   List<String> selectedmeasures=[];
  String brandname='';
  String productname='';
  var category;
  var sub_category;
  String startDateFormatted='';
  String endDateFormatted='';
  String startDateString = "";
  String endDateString="";
  bool ischeck=false;
  List<Map<String, String>> selectedCategories = [];
  List<String> selectedvalue = [];
  List<String> selectedValues=[];
  int total=0;
  String formattedTotalbranch='';
  String formattedTotalchannel='';
  final formatter = NumberFormat('#,###');
  String formattedTotals='';
  int totalcompany=0;
  int totalbranch=0;
  String selectedCategory = '';
  String categorypopup='';
  SalesHeirarchyViewModel view=SalesHeirarchyViewModel();
  CompanyHeirarchyViewModel viewModel = CompanyHeirarchyViewModel();
  bool isLoading = false;
  bool date=false;
  String reporting='T-${empcode.auth}';
  //String companycodes='';
  Set<String> empCodeSet={};
  final sales=SalesHeirarchyViewModel();
  DateFormat dateFormat = DateFormat('yyyy,MM,dd');

///companies
  Future<void> executeApiCall(String start, String end, List<String> measures) async {
    setState(
            () {
          isLoading = true;
        }
    );
    try {

      String startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      String endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
      setState(() {

      });
      final result = await team_company_Repository().team_company_fetchData(start,end,widget.name,measures);

      // Process the result as needed
      print('API Result: $result');


      setState(() {

        totalcompany=0;
        team = result;
        filterlist=team;

        isLoading=false;
        print("team$team");
        company = true;
        showDateContainers = true;
        // Navigator.of(context).pop();
        for (int i = 0; i < team.length; i++) {
          setState(() {
            totalcompany += (double.tryParse(team[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

            formattedTotals = formatter.format(totalcompany);
          });
        }
      });
    } catch (e) {
      // Handle errors
      setState(() {

        isLoading = false;

      });
      print('Error: $e');
    }finally {
      setState(() {

        isLoading = false;
      });
    }
  }

///all_companies
  Future<void> all(String start, String end, List<String> measures) async {
    setState(
            () {
      isLoading = true;
    }
    );
      try {

         DateTime now = DateTime.now();
         DateTime startDates = DateTime(now.year, now.month, 1);
         DateTime endDates = DateTime(now.year, now.month + 1, 0);
         setState(() {

         });
        final result = await team_company_Repository_all().team_company_fetchData(start,end,widget.name,measures);

        // Process the result as needed
        print('API Result: $result');


        setState(() {

          totalcompany=0;
          team = result;
          filterlist=team;
          isLoading=false;
          company = true;
          showDateContainers = true;
         // Navigator.of(context).pop();
          for (int i = 0; i < team.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(team[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

              formattedTotals = formatter.format(totalcompany);
            });
          }
        });
      } catch (e) {
        // Handle errors
        setState(() {

          isLoading = false;

        });
        print('Error: $e');
      }finally {
        setState(() {

          isLoading = false;
        });
      }
  }
///branches
  Future<void> getbracnhes(int companycodes, String start, String end) async {
    if (startDate != null && endDate != null)
    {
      try {
        String startDateFormatted = DateFormat('yyyy-MM-dd').format(startDate!);
        String endDateFormatted = DateFormat('yyyy-MM-dd').format(endDate!);
        final result = await get_branches_Repository().fetchData(
          start,
            end,
            [companycodes],
        );
        print('API Result: $result');
        setState(() {
          branches = result;
          company = true;
          date=true;
        });
      } catch (e) {
        // Handle errors
        print('Error: $e');
      }
    }
  }
///channels
  Future<void> getchannel(int companycodes, String start, String end) async {
    if (startDate != null && endDate != null)
    {
      String startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      String endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
      try {
        final result = await get_channel_Repository().fetchData(

          start,
          end,
            [companycodes],

          // Add other parameters as needed
        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {

          channel = result;
          company = true;
          date=true;
        });
      } catch (e) {
        // Handle errors
        print('Error: $e');
      }
    }
  }

  ///brand
  Future<void> get_division(String start, String end, List<String> companycodes,List<String> branchcodes,List<String> divisioncodes,List<String> categorycodes,List<String> subcategorycodes,List<String> sku,List<String> measures ) async {
    setState(() {
      isLoading = true;
    });
    if (startDate != null && endDate != null && widget.name!="Company")
    {
      try {
        final result = await division_Repository().fetchData(

    start,
          end,
            widget.name,
            companycodes,
            branchcodes,
            divisioncodes,
            categorycodes,
            subcategorycodes,
          measures


        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {
          totalcompany=0;
          division = result;
          isLoading=false;
          company = true;
          date=true;
          showDateContainers=true;
          for (int i = 0; i < division.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(division[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

              formattedTotals = formatter.format(totalcompany);
            });
          }
        });
      } catch (e) {
        isLoading = false;
        // Handle errors
        print('Error: $e');
      }
    }

    if (startDate != null && endDate != null && widget.name=="Company")
    {
      try {
        final result = await division_Repository().fetchDataall(

          start,
          end,
          companycodes,
          branchcodes,
          divisioncodes,
          categorycodes,
          subcategorycodes,
          measures


        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {
          totalcompany=0;
          division = result;
          isLoading=false;
          company = true;
          date=true;
          showDateContainers=true;
          for (int i = 0; i < division.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(division[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

              formattedTotals = formatter.format(totalcompany);
            });
          }
        });
      } catch (e) {
        isLoading = false;
        // Handle errors
        print('Error: $e');
      }
    }

  }
///category
  Future<void> get_category(List<String> companycodes, String start,String end, List<String> measures) async {
                     setState(() {
                       isLoading=true;
                     });
    if (startDate != null && endDate != null && widget.name!="Company")
    {
      try {

        final result = await category_Repository().fetchData(
          start,
          end,
             widget.name,
            companycodes,
            measures

        );

        print('API Result: $result');

        setState(() {

          category = result;
          company = true;
          date=true;
          isLoading=false;


            totalcompany=0;
            company = true;
            showDateContainers = true;
            // Navigator.of(context).pop();
            for (int i = 0; i < category.length; i++) {
              setState(() {
                totalcompany += (double.tryParse(category[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

                formattedTotals = formatter.format(totalcompany);
              });
            }

        });
      } catch (e) {
       setState(() {
        isLoading=false;
       });
        print('Error: $e');
      }
    }

    else  if (startDate != null && endDate != null && widget.name=="Company")
    {
      try {

        final result = await category_Repository().fetchDataall(
          start,
          end,
          companycodes,
          measures

          // Add other parameters as needed
        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {

          category = result;
          company = true;
          date=true;
          isLoading=false;


          totalcompany=0;
          company = true;
          showDateContainers = true;
          // Navigator.of(context).pop();
          for (int i = 0; i < category.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(category[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

              formattedTotals = formatter.format(totalcompany);
            });
          }

        });
      } catch (e) {
        setState(() {
          isLoading=false;
        });
        print('Error: $e');
      }
    }




    else {
      // Show a message or perform any action if dates are not selected
      Utils.snackBarred('Please select start and end dates', context);

    }
  }


//sub_category
  Future<void> get_sub_category(String start, String end,List<String> companycodes,List<String> branchcodes,List<String> divisioncodes,List<String> categorycodes,List<String> subcategorycodes,List<String> sku,List<String> measures) async {

    setState(() {
      isLoading=true;
    });
    if (startDate != null && endDate != null && widget.name!="Company")
    {
      try {
        final result = await sub_category_Repository().fetchData(
          start,
          end,
            widget.name,
            companycodes,
            branchcodes,
            divisioncodes,
            subcategorycodes,
            categorycodes,
            measures

        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {
          totalcompany=0;
          sub_category = result;
          company = true;
          date=true;
          isLoading=false;
          showDateContainers=true;
          for (int i = 0; i < sub_category.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(sub_category[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();
              formattedTotals = formatter.format(totalcompany);
            });
          }
        });
      } catch (e) {
        // Handle errors
        isLoading=false;
        print('Error: $e');
      }
    }
    else if (startDate != null && endDate != null && widget.name=="Company")
    {
      try {
        final result = await sub_category_Repository().fetchDataall(
          start,
          end,
          companycodes,
          branchcodes,
          divisioncodes,
          subcategorycodes,
          categorycodes,
          measures
        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {
          totalcompany=0;
          sub_category = result;
          company = true;
          date=true;
          isLoading=false;
          showDateContainers=true;
          for (int i = 0; i < sub_category.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(sub_category[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

              formattedTotals = formatter.format(totalcompany);
            });
          }
        });
      } catch (e) {
        // Handle errors
        isLoading=false;
        print('Error: $e');
      }
    }




  }


  ////product
  Future<void> sku(String start, String end, List<String> companycodes,List<String> branchcodes,List<String> divisioncodes,List<String> categorycodes,List<String> subcategorycodes,List<String> sku,List<String> measures) async {
    setState(() {
      isLoading=true;
    });
    if (startDate != null && endDate != null && widget.name!="Company")
    {
      try {
        final result = await sku_Repository().fetchData(
    start,
          end,
            widget.name,
            companycodes,
          branchcodes,
          divisioncodes,
          subcategorycodes,
          categorycodes,
          measures
        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {
          totalcompany=0;
          skumodel = result;
          company = true;
          isLoading=false;
          date=true;
          showDateContainers=true;
          for (int i = 0; i < skumodel.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(skumodel[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

              formattedTotals = formatter.format(totalcompany);
            });
          }
        });
      } catch (e) {
        isLoading=false;
        // Handle errors
        print('Error: $e');
      }
    }
   else if (startDate != null && endDate != null && widget.name=="Company")
    {
      try {
        final result = await sku_Repository().fetchDataall(

          start,
          end,
          companycodes,
          branchcodes,
          divisioncodes,
          subcategorycodes,
          categorycodes,
          measures

          // Add other parameters as needed
        );

        // Process the result as needed
        print('API Result: $result');

        // Update the UI or perform any other actions based on the API result
        setState(() {
          totalcompany=0;
          skumodel = result;
          company = true;
          isLoading=false;
          date=true;
          showDateContainers=true;
          for (int i = 0; i < skumodel.length; i++) {
            setState(() {
              totalcompany += (double.tryParse(skumodel[i]["Sales_Inc_ST"].toString().replaceAll(',', '')) ?? 0).toInt();

              formattedTotals = formatter.format(totalcompany);
            });
          }
        });
      } catch (e) {
        isLoading=false;
        // Handle errors
        print('Error: $e');
      }
    }

  }

  ////search
  String searchQuery = '';
  void filterList(String query) {
    setState(() {
      searchQuery = query;
      filterlist = team
          .where((item) => item["Product_Company_Name"]
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  bool company=false;
  final companyheirarchy= CompanyHeirarchyViewModel();



  void initState() {
   // print("selectedmeasure:$selectedmeasures");

    showDateContainers = true;
    super.initState();

    DateTime now = DateTime.now();
    DateTime startDateinitial = DateTime(now.year, now.month, 1);

// Get the last day of the current month
    DateTime endDateinitial = DateTime(now.year, now.month, now.day);
    setState(() {
      startDate=startDateinitial;
     endDate=endDateinitial;
    });

// Format dates as strings in "yyyy-MM-dd" format
    String startDateString = widget.startdate != null ? DateFormat('yyyy,MM,dd').format(widget.startdate!) : '';
    String endDateString = widget.enddate != null ? DateFormat('yyyy,MM,dd').format(widget.enddate!) : '';


    if(widget.name=="PCP") {
      executeApiCall(startDateString, endDateString,selectedmeasures);
      setState(() {
        selectedmeasures=[];
      });
      print("selectedmeasure:$selectedmeasures");

    }
    if(widget.name=="CONSUMER") {
      executeApiCall(startDateString, endDateString,selectedmeasures);
    }

    if(widget.name=="FMCG") {
      executeApiCall(startDateString, endDateString,selectedmeasures);
    }

    if(widget.name=="PHARMA") {
      executeApiCall(startDateString, endDateString,selectedmeasures);
    }
    if(widget.name=="Company") {
      all(startDateString, endDateString,selectedmeasures);
    }
  }


  bool showDateContainers = false;

  GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  DateTime? startDate;
  DateTime? endDate;
  List<String> concatenatedList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey1,
      appBar: AppBar(
        title: Text(' ${widget.name.toString()}'),
        backgroundColor: Colors.green[800],
        actions: [
          Container(
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.share, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 6),
                          Text('Share', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      value: 'share',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.calendar_today, color: Colors.white, size: 14),
                          ),
                          SizedBox(width: 3),
                          Text(showDateContainers ? 'Dates Show' : 'Dates Hide', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      value: 'date',
                    ),

                    PopupMenuItem(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.filter_list, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 6),
                          Text('Measures', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 6),

                        ],
                      ),
                      value: 'filters',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.format_list_numbered, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 6),
                          Text(ischeck ? 'Without 0s' : 'With 0s', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      value: 'sales',
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'share') {

                    String combinedMessage = '';
                    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);// Initialize the combined message outside the loop
                   if(widget.name=="Company" || widget.name!="Company" && categorypopup=="")
                    for (int i = 0; i < team.length; i++) {

                      String name = team[i]["Product_Company_Name"];
                      int id = team[i]["Product_Company_Code"];


                     String sale = NumberFormat('#,###').format(double.parse(team[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));

                      combinedMessage +=
                      "Company Name: $name\nID: $id\nSale: $sale\n";

                      combinedMessage += List.generate(
                        selectedmeasures.length,
                            (index) {
                          final measure = selectedmeasures[index];
                          final teamValue = team[i][measure.toString().replaceAll(' ', '_')];
                          final formattedValue = teamValue != null ? (measure.endsWith('%') ? teamValue.toString() : formatter.format(teamValue).toString()) : '0';
                          return "$measure: $formattedValue";
                        },
                      ).join('\n');




                      combinedMessage +="\n\n";

                    }
                    if(categorypopup=="Category")
                      for (int i = 0; i < category.length; i++) {

                        String name = category[i]["Product_Category_Name"];
                        int id = category[i]["Product_Category_Code"];
                        String sale = NumberFormat('#,###').format(double.parse(category[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));

                        combinedMessage +=
                        "Category Name: $name\nID: $id\nSale: $sale\n\n";
                        combinedMessage += List.generate(
                          selectedmeasures.length,
                              (index) {
                            final measure = selectedmeasures[index];
                            final teamValue = team[i][measure.toString().replaceAll(' ', '_')];
                            final formattedValue = teamValue != null ? (measure.endsWith('%') ? teamValue.toString() : formatter.format(teamValue).toString()) : '0';
                            return "$measure: $formattedValue";
                          },
                        ).join('\n');




                        combinedMessage +="\n\n";

                      }
                    if(categorypopup=="Sub Category")
                      for (int i = 0; i < sub_category.length; i++) {

                        String name = sub_category[i]["Product_SubCategory_Name"];
                        int id = sub_category[i]["Product_SubCategory_Code"];
                        String sale = NumberFormat('#,###').format(double.parse(sub_category[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));

                        combinedMessage +=
                        "Sub_Category Name: $name\nID: $id\nSale: $sale\n\n";
                        combinedMessage += List.generate(
                          selectedmeasures.length,
                              (index) {
                            final measure = selectedmeasures[index];
                            final teamValue = team[i][measure.toString().replaceAll(' ', '_')];
                            final formattedValue = teamValue != null ? (measure.endsWith('%') ? teamValue.toString() : formatter.format(teamValue).toString()) : '0';
                            return "$measure: $formattedValue";
                          },
                        ).join('\n');




                        combinedMessage +="\n\n";

                      }
                    if(categorypopup=="Brand")
                      for (int i = 0; i < division.length; i++) {

                        String name = division[i]["Product_Brand_Name"];
                        int id = division[i]["Product_Brand_Code"];
                        String sale = NumberFormat('#,###').format(double.parse(division[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));

                        combinedMessage +=
                        "Brand Name: $name\nID: $id\nSale: $sale\n\n";

                      }
                    if(categorypopup=="Product")
                      for (int i = 0; i < skumodel.length; i++) {

                        String name = skumodel[i]["Product_Product_Name"];
                        String sale = NumberFormat('#,###').format(double.parse(skumodel[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));

                        combinedMessage +=
                        "Product Name: $name\nSale: $sale\n\n";
                        combinedMessage += List.generate(
                          selectedmeasures.length,
                              (index) {
                            final measure = selectedmeasures[index];
                            final teamValue = team[i][measure.toString().replaceAll(' ', '_')];
                            final formattedValue = teamValue != null ? (measure.endsWith('%') ? teamValue.toString() : formatter.format(teamValue).toString()) : '0';
                            return "$measure: $formattedValue";
                          },
                        ).join('\n');




                        combinedMessage +="\n\n";

                      }
                    Share.share("Start Date: $startDateFormatted\nEnd Date: $endDateFormatted\n\n $combinedMessage", subject: 'Sales Information');
                  }
                  // Handle menu item selection here
                  if (value == 'sales') {
                    setState(() {
                      ischeck = !ischeck;
                    });
                  }
                  if (value == 'date') {
                    setState(() {
                      company=!company;
                      showDateContainers = !showDateContainers;
                    });
                  }
                  if (value == 'filters') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return filters(
                          onSelectionDone: (selectedValues) {
                            setState(() {
                              selectedmeasures=selectedValues.toList();
                            });
                            // Use selectedValues here
                            String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                            String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                            print(selectedValues);
                            if(widget.name=="PCP" &&  categorypopup=="") {
                              executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="CONSUMER" &&  categorypopup=="") {
                              executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                            }

                            if(widget.name=="FMCG" &&  categorypopup=="") {
                              executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                            }

                            if(widget.name=="PHARMA" &&  categorypopup=="") {
                              executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="Company" && categorypopup=="") {
                              all(startDateFormatted, endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="Company" && categorypopup=="Category") {
                              get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="Company" && categorypopup=="Sub Category") {
                              get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="Company" && categorypopup=="Brand") {
                              get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="Company" && categorypopup=="Product") {
                              sku(
                                  startDateFormatted,endDateFormatted,
                                  companyid.isEmpty ? [] : [companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                  [],brandid.isEmpty ? [] : [brandid],[],selectedmeasures
                              );
                            }
                            if(widget.name=="PCP" && categorypopup=="Category") {
                              get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="PCP" && categorypopup=="Sub Category") {
                              get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="PCP" && categorypopup=="Brand") {
                              get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="PCP" && categorypopup=="Product") {
                              sku(
                                  startDateFormatted,endDateFormatted,
                                  companyid.isEmpty ? [] : [companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                  [],brandid.isEmpty ? [] : [brandid],[],selectedmeasures
                              );
                            }
                            if(widget.name=="PHARMA" && categorypopup=="Category") {
                              get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="PHARMA" && categorypopup=="Sub Category") {
                              get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="PHARMA" && categorypopup=="Brand") {
                              get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="PHARMA" && categorypopup=="Product") {
                              sku(
                                  startDateFormatted,endDateFormatted,
                                  companyid.isEmpty ? [] : [companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                  [],brandid.isEmpty ? [] : [brandid],[]
                                  ,selectedmeasures);
                            }
                            if(widget.name=="CONSUMER" && categorypopup=="Category") {
                              get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="CONSUMER" && categorypopup=="Sub Category") {
                              get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="CONSUMER" && categorypopup=="Brand") {
                              get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="CONSUMER" && categorypopup=="Product") {
                              sku(
                                  startDateFormatted,endDateFormatted,
                                  companyid.isEmpty ? [] : [companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                  [],brandid.isEmpty ? [] : [brandid],[],selectedmeasures
                              );
                            }
                            if(widget.name=="FMCG" && categorypopup=="Category") {
                              get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                            }
                            if(widget.name=="FMCG" && categorypopup=="Sub Category") {
                              get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="FMCG" && categorypopup=="Brand") {
                              get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                            }
                            if(widget.name=="FMCG" && categorypopup=="Product") {
                              sku(
                                  startDateFormatted,endDateFormatted,
                                  companyid.isEmpty ? [] : [companyid],
                                  categoryid.isEmpty ? [] : [categoryid],
                                  sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                  [],brandid.isEmpty ? [] : [brandid],[],selectedmeasures
                              );
                            }
                          },
                          selectedvalues: selectedmeasures,
                        );

                      },
                    );
                  }
                  if (value == 'sales') {
                    setState(() {
                     // ischeck = !ischeck;
                    });
                  } else {
                    print('Selected: $value');
                  }
                },
              ),
            ),



        ],
      ),

      body: isLoading ?  Padding(
        padding: const EdgeInsets.all(8.0),
      
          child: Center(child: CircularProgressIndicator(color: Colors.green[800],)),
      ) :
        Column(children: [
     Container(
       height: 50,
       decoration: BoxDecoration(color: Colors.green[800]),
       child:
       Padding(
         padding: const EdgeInsets.only(left: 10, right: 10),
         child:  Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: [
             InkWell(
             onTap: () {
    setState(() {
    categorypopup = '';
    companyid='';
    sub_categoryid='';
    categoryid='';
    brandid='';

    viewModel.items = ["Category", "Sub Category", "Brand", "Product"];
    selectedCategories.clear();
    print("item${viewModel.items}");
    print(selectedCategories);
    company = true;
    showDateContainers = false;
    });
    if (widget.name == "Company") {
    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
    all(startDateFormatted, endDateFormatted,selectedmeasures);
    } else {
    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
    executeApiCall(startDateFormatted, endDateFormatted,selectedmeasures);
    }
    },
    child: Padding(
    padding: const EdgeInsets.only(left: 7, right: 7),
    child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: Colors.red,
    ),
    child: Padding(
    padding: const EdgeInsets.all(6.0),
    child: Text(
    "Root",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
    ),
    ),
    ),
    ),
    ),

               Expanded(
                 child: ListView.builder(
                   scrollDirection: Axis.horizontal,
                   itemCount: selectedCategories.length,
                   itemBuilder: (context, index) {

                       String category = selectedCategories[index]['category'].toString();
                     String name = selectedCategories[index]['name'].toString();


                       return InkWell(
                         onTap: () {
                           setState(() {

                             if (category == "Category") {
                               viewModel.items = ["Sub Category", "Brand", "Product"];
                               sub_categoryid='';
                               brandid='';
                               productid='';
                               selectedCategories[index];
                               int selectedIndex = index - 1;
                               selectedCategories.removeRange(index + 1, selectedCategories.length);
                               String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                               String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                               get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                               categorypopup = 'Category';
                             }
                             else if
                             (category == "Sub Category") {
                               viewModel.items = ["Brand", "Product"];
                               brandid='';
                               productid='';
                               int selectedIndex = index - 1;
                               selectedCategories.removeRange(index + 1, selectedCategories.length);
                               //selectedCategories.removeWhere((item) => item != "Sub Category");
                               String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                               String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                               get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                   categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                               categorypopup = 'Sub Category';
                             }
                             else if
                             (category == "Brand") {
                               viewModel.items = ["Product"];
                               productid='';
                               int selectedIndex = index - 1;
                               selectedCategories.removeRange(index + 1, selectedCategories.length);
                               //selectedCategories.removeWhere((item) => item != "Sub Category");
                               String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                               String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                               get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                   categoryid.isEmpty ? [] : [categoryid],
                                   sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                               categorypopup = 'Brand';
                             }
                             else if
                             (category == "Product") {


                               //selectedCategories.removeRange(selectedIndex + 1, selectedCategories.length);
                               //selectedCategories.removeWhere((item) => item != "Sub Category");
                               String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                               String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);

                               sku(
                                   startDateFormatted,endDateFormatted,
                                 companyid.isEmpty ? [] : [companyid],
                                 categoryid.isEmpty ? [] : [categoryid],
                                 sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                 [],brandid.isEmpty ? [] : [brandid],[]
                                   ,selectedmeasures);
                               categorypopup = 'Product';
                             }
                           });
                         },
                         child:  Padding(
                           padding: const EdgeInsets.only(left: 10),
                           child: Container(
                             height: 50,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(12),
                                 color: Colors.white,
                               ),

                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                   children: [
                                     Text(
                                       "${category.toUpperCase()}, ",
                                       style: TextStyle(
                                         color: Colors.black,
                                         fontWeight: FontWeight.bold,
                                         fontSize: 11,
                                       ),
                                     ),

                                     Text(
                                       name,
                                       style: TextStyle(
                                         color: Colors.green[800],
                                         fontWeight: FontWeight.bold,
                                           fontSize: 11

                                       ),
                                     ),


                                   ],
                                 ),
                               ),
                             ),
                         ),

                       );
                   },
                 ),
               ),

             ],
           ),
         ),
       ),
     ),

          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child:
           Visibility(
             child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Flexible(
                        child: DateContainer(
                          title: "Start Date",
                          range: "yyyy-MM-dd",
                          selectedDate: widget.startdate,
                          isVisible: !showDateContainers,
                          onDateSelected: (date) {
                            setState(() {
                              widget.startdate = date;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02,
                      ), // Adjust the percentage as needed
                      Flexible(
                        child: DateContainer(
                          title: "End Date",
                          range: "yyyy-MM-dd",
                          selectedDate: widget.enddate,
                          isVisible: !showDateContainers  ,
                          onDateSelected: (date) async {
                            setState(() {

                              widget.enddate = date;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
           ),
           ),
if(categorypopup=='')
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
           color: Colors.green[800] ?? Colors.green, // Set border color here
          width: 1.0, // Set border width here
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: ' Search...',
                border: InputBorder.none,
              ),
onChanged: (value)
{
  filterList(value);
},
            ),

          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.green[800],),
            onPressed: () {
              // Implement your search logic here
            },
          ),
        ],
      ),
    ),
  ),


          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Start Date: ${widget.startdate.toString().split(' ')[0]} ", style: TextStyle(color:  Colors.green[800],fontWeight: FontWeight.bold),), // Display only the date part
                Text("End Date: ${widget.enddate.toString().split(' ')[0]}", style: TextStyle(color:  Colors.green[800],fontWeight: FontWeight.bold)), // Display only the date part
              ],
            ),
          ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(color: Colors.green[800],),
                  )   ,
          Expanded(
            child:

            Padding(
              padding: const EdgeInsets.all(8.0),
              child:categorypopup=='' ?


              ListView.builder(

                  itemCount: filterlist?.length ?? 0,

                  shrinkWrap: true,

                  itemBuilder: (context, index) {
                    print("team${team.length}");
                    filterlist.sort((a, b) {
                      String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
                      String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

                      double aSales = double.tryParse(aSalesStr) ?? 0;
                      double bSales = double.tryParse(bSalesStr) ?? 0;

                     // print('aSales: $aSales, bSales: $bSales');

                      return bSales.compareTo(aSales);
                    });



                    var item = filterlist[index];

                    return

                      Column(
                        children: [
                          if(item['Sales_Inc_ST']!=null && ischeck==false )
                          Padding(

                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: (){
    viewModel.category(context, (String category) {

      setState(() {
        companyid=item["Product_Company_Code"].toString();
        companyname=item["Product_Company_Name"].toString();
        categorypopup=category;

        selectedCategories.add({
          "category": category.toString(),
          "name": companyname.toString(),
        });



      });
if(categorypopup=="Brand"){
setState(() {
  productid='';
});

String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
    categoryid.isEmpty ? [] : [categoryid],
    sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);


}
      if(categorypopup=="Category"){
        setState(() {
          sub_categoryid='';
          brandid='';
          productid='';
        });
        String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
        String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
        get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);


      }
      if(categorypopup=="Sub Category"){
        setState(() {
          brandid='';
          productid='';
        });
       String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
        String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
        get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
            categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);


      }
      if(categorypopup=="Product"){

        String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
        String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
        sku(
            startDateFormatted,endDateFormatted,
            companyid.isEmpty ? [] : [companyid],
            categoryid.isEmpty ? [] : [categoryid],
            sub_categoryid.isEmpty ? [] : [sub_categoryid],

            [],brandid.isEmpty ? [] : [brandid],[]
            ,selectedmeasures);


      }
    print('Selected Category: $selectedCategory');
                              });},
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Circle_avater(index: index + 1),
                                      SizedBox(width: 5,),
                                      Expanded(
                                          flex: 6,
                                          child: Text(item['Product_Company_Name'], style: TextStyle(color: Colors.green[800],fontSize: 15, fontWeight: FontWeight.bold),)),
                                      Spacer(),
                                      Text(
                                        NumberFormat('#,###').format(double.parse(item['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0')),
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                 // SizedBox(height: 10,),
                                  if (selectedmeasures.isNotEmpty)
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(selectedmeasures.length, (index) {
                                        var selectedMeasureKey = selectedmeasures[index].toString().replaceAll(' ', '_');
                                        var itemValue = item[selectedMeasureKey];

                                        // Check if itemValue is a numeric value
                                        var formattedValue = itemValue is num ? formatter.format(itemValue).toString() : '0';

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5,),
                                            RichText(
                                              text: TextSpan(
                                                style: DefaultTextStyle.of(context).style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: selectedmeasures[index] != null ? "${selectedmeasures[index].toString()}: " : '',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: selectedmeasures[index] != null && itemValue != null
                                                        ? (itemValue is String && itemValue.endsWith('%')
                                                        ? itemValue
                                                        : formattedValue)
                                                        : '0',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.green[800],
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 3,),
                                          ],
                                        );
                                      }),
                                    ),
                                  SizedBox(height: 10,),
                                  //ElevatedButton(onPressed: (){}, child: Text('Get Channels')),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          // Show loading dialog
                                          sales.showLoadingDialog(context);

                                          try {
                                            String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                            String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                            //int companyIdInt = int.tryParse(companyid) ?? 0;
                                            print(item["Product_Company_Code"]);// Provide a default value if conversion fails
                                            await getbracnhes(item["Product_Company_Code"], startDateFormatted,endDateFormatted);
                                            Navigator.pop(context);
                                            setState(() {
                                              totalbranch=0;
                                            });

                                            for (int i = 0; i < branches.length; i++) {
                                              setState(() {
                                                totalbranch += int.tryParse(branches[i].Sales.replaceAll(',', '')) ?? 0;
                                                formattedTotalbranch = formatter.format(totalbranch);
                                              });

                                            }
                                            viewModel.showCompanyDetailsDialog(context, branches,item["Product_Company_Code"].toString(), formattedTotalbranch.toString(),item["Product_Company_Name"].toString());
                                          } catch (e) {
                                            print('Error fetching branches: $e');
                                            Navigator.pop(context);
                                          }
                                        },

                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.green[800],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Get Branches",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          sales.showLoadingDialog(context);

                                          try {
                                            String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                            String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                            await getchannel(item["Product_Company_Code"],startDateFormatted, endDateFormatted);

                                            Navigator.pop(context);
                                            CompanyHeirarchyViewModel viewModel = CompanyHeirarchyViewModel();
                                            setState(() {
                                              total=0;
                                            });

                                            for (int i = 0; i < channel.length; i++) {
                                              setState(() {
                                                total += int.tryParse(channel[i].Sales.replaceAll(',', '')) ?? 0;
                                                formattedTotalchannel = formatter.format(total);
                                              });

                                            }

                                            viewModel.showchannelDetailsDialog(context, channel, item["Product_Company_Code"].toString(), formattedTotalchannel.toString(), item["Product_Company_Name"].toString());
                                          } catch (e) {

                                            print('Error fetching branches: $e');


                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Container(

                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.green[800],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Get Channels",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Divider(color: Colors.green[800]),
                                ],
                              ),
                            ),
                          ),
                         if(ischeck==true)
                           Padding(

                             padding: const EdgeInsets.all(4.0),
                             child: InkWell(
                               onTap: (){
                                 viewModel.category(context, (String category) {

                                   setState(() {
                                     companyid=item["Product_Company_Code"].toString();
                                     companyname=item["Product_Company_Name"].toString();
                                     categorypopup=category;

                                     selectedCategories.add({
                                       "category": category.toString(),
                                       "name": companyname.toString(),
                                     });



                                   });
                                   if(categorypopup=="Brand"){
                                     setState(() {
                                       productid='';
                                     });

                                     String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                     String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                     get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                         categoryid.isEmpty ? [] : [categoryid],
                                         sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);


                                   }
                                   if(categorypopup=="Category"){
                                     setState(() {
                                       sub_categoryid='';
                                       brandid='';
                                       productid='';
                                     });
                                     String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                     String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                     get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);


                                   }
                                   if(categorypopup=="Sub Category"){
                                     setState(() {
                                       brandid='';
                                       productid='';
                                     });
                                     String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                     String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                     get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                         categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);


                                   }
                                   if(categorypopup=="Product"){

                                     String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                     String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                     sku(
                                         startDateFormatted,endDateFormatted,
                                         companyid.isEmpty ? [] : [companyid],
                                         categoryid.isEmpty ? [] : [categoryid],
                                         sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                         [],brandid.isEmpty ? [] : [brandid],[]
                                         ,selectedmeasures);


                                   }
                                   print('Selected Category: $selectedCategory');
                                 });},
                               child:
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [

                                   Row(
                                     children: [
                                       Circle_avater(index: index + 1),
                                       SizedBox(width: 5,),
                                       Expanded(
                                           flex: 6,
                                           child: Text(item['Product_Company_Name'], style: TextStyle(color: Colors.green[800],fontSize: 15, fontWeight: FontWeight.bold),)),
                                       Spacer(),
                                       Text(
                                         NumberFormat('#,###').format(double.parse(item['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0')),
                                         style: TextStyle(
                                           color: Colors.red,
                                           fontSize: 17,
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                     ],
                                   ),
                                   // SizedBox(height: 10,),
                                   if (selectedmeasures.isNotEmpty)
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: List.generate(selectedmeasures.length, (index) {
                                         var selectedMeasureKey = selectedmeasures[index].toString().replaceAll(' ', '_');
                                         var itemValue = item[selectedMeasureKey];

                                         // Check if itemValue is a numeric value
                                         var formattedValue = itemValue is num ? formatter.format(itemValue).toString() : '0';

                                         return Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             SizedBox(height: 5,),
                                             RichText(
                                               text: TextSpan(
                                                 style: DefaultTextStyle.of(context).style,
                                                 children: <TextSpan>[
                                                   TextSpan(
                                                     text: selectedmeasures[index] != null ? "${selectedmeasures[index].toString()}: " : '',
                                                     style: TextStyle(
                                                         fontSize: 13,
                                                         color: Colors.green,
                                                         fontWeight: FontWeight.w500
                                                     ),
                                                   ),
                                                   TextSpan(
                                                     text: selectedmeasures[index] != null && itemValue != null
                                                         ? (itemValue is String && itemValue.endsWith('%')
                                                         ? itemValue
                                                         : formattedValue)
                                                         : '0',
                                                     style: TextStyle(
                                                       fontSize: 13,
                                                       color: Colors.green[800],
                                                       fontWeight: FontWeight.bold,
                                                     ),
                                                   )
                                                 ],
                                               ),
                                             ),
                                             SizedBox(height: 3,),
                                           ],
                                         );
                                       }),
                                     ),




                                   SizedBox(height: 10,),
                                   //ElevatedButton(onPressed: (){}, child: Text('Get Channels')),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       GestureDetector(
                                         onTap: () async {
                                           // Show loading dialog
                                           sales.showLoadingDialog(context);

                                           try {
                                             String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                             String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                             //int companyIdInt = int.tryParse(companyid) ?? 0;
                                             print(item["Product_Company_Code"]);// Provide a default value if conversion fails
                                             await getbracnhes(item["Product_Company_Code"], startDateFormatted,endDateFormatted);
                                             Navigator.pop(context);
                                             setState(() {
                                               totalbranch=0;
                                             });

                                             for (int i = 0; i < branches.length; i++) {
                                               setState(() {
                                                 totalbranch += int.tryParse(branches[i].Sales.replaceAll(',', '')) ?? 0;
                                                 formattedTotalbranch = formatter.format(totalbranch);
                                               });

                                             }
                                             viewModel.showCompanyDetailsDialog(context, branches,item["Product_Company_Code"].toString(), formattedTotalbranch.toString(),item["Product_Company_Name"].toString());
                                           } catch (e) {
                                             print('Error fetching branches: $e');
                                             Navigator.pop(context);
                                           }
                                         },

                                         child: Container(
                                           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                           decoration: BoxDecoration(
                                             color: Colors.green[800],
                                             borderRadius: BorderRadius.circular(8),
                                           ),
                                           child: Center(
                                             child: Text(
                                               "Get Branches",
                                               style: TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 10,
                                               ),
                                             ),
                                           ),
                                         ),

                                       ),
                                       GestureDetector(
                                         onTap: () async {
                                           sales.showLoadingDialog(context);

                                           try {
                                             String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                             String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                             await getchannel(item["Product_Company_Code"],startDateFormatted, endDateFormatted);

                                             Navigator.pop(context);
                                             CompanyHeirarchyViewModel viewModel = CompanyHeirarchyViewModel();
                                             setState(() {
                                               total=0;
                                             });

                                             for (int i = 0; i < channel.length; i++) {
                                               setState(() {
                                                 total += int.tryParse(channel[i].Sales.replaceAll(',', '')) ?? 0;
                                                 formattedTotalchannel = formatter.format(total);
                                               });

                                             }

                                             viewModel.showchannelDetailsDialog(context, channel, item["Product_Company_Code"].toString(), formattedTotalchannel.toString(), item["Product_Company_Name"].toString());
                                           } catch (e) {

                                             print('Error fetching branches: $e');


                                             Navigator.pop(context);
                                           }
                                         },
                                         child: Container(

                                           padding: EdgeInsets.all(8),
                                           decoration: BoxDecoration(
                                             color: Colors.green[800],
                                             borderRadius: BorderRadius.circular(8),
                                           ),
                                           child: Center(
                                             child: Text(
                                               "Get Channels",
                                               style: TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 10,
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),

                                   Divider(color: Colors.green[800]),
                                 ],
                               ),
                             ),
                           ),
                        ],
                      );

                  })
                  :categorypopup=='Brand'?
              ListView.builder(

                  itemCount: division.length,

                  shrinkWrap: true,

                  itemBuilder: (context, index) {
                    division.sort((a, b) {
                      String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
                      String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

                      double aSales = double.tryParse(aSalesStr) ?? 0;
                      double bSales = double.tryParse(bSalesStr) ?? 0;

                      // print('aSales: $aSales, bSales: $bSales');

                      return bSales.compareTo(aSales);
                    });
                    var item = division[index];


                    return

                      Column(
                        children: [
                          if(item['Sales_Inc_ST']!=null && ischeck==false )
                          Padding(

                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: (){
                                //sales.showLoadingDialog(context);
                                viewModel.category(context, (String category) {

                                  setState(() {
                                    brandid=item["Product_Brand_Code"].toString();
                                    categorypopup=category;
                                    brandname=item["Product_Brand_Name"].toString();

                                   // selectedCategories.add("category": category, "name":co);
                                    selectedCategories.add({
                                      "category": category.toString(),
                                      "name": brandname.toString(),
                                    });
                                    selectedvalue.add(companyname);
                                  });

    if(categorypopup=="Product"){

      String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
      String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
      sku(
          startDateFormatted,endDateFormatted,
          companyid.isEmpty ? [] : [companyid],
          categoryid.isEmpty ? [] : [categoryid],
          sub_categoryid.isEmpty ? [] : [sub_categoryid],

          [],brandid.isEmpty ? [] : [brandid],[]
          ,selectedmeasures);
    }
                                  print('Selected Category: $selectedCategory');
                                });},
                              child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: "Product_Brand_Name",
                                code: "Product_Brand_Code"
                            ),
                            ),
                          ),
                          if(ischeck==true )
                            Padding(

                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: (){
                                  //sales.showLoadingDialog(context);
                                  viewModel.category(context, (String category) {

                                    setState(() {
                                      brandid=item["Product_Brand_Code"].toString();
                                      categorypopup=category;
                                      brandname=item["Product_Brand_Name"].toString();

                                      // selectedCategories.add("category": category, "name":co);
                                      selectedCategories.add({
                                        "category": category.toString(),
                                        "name": brandname.toString(),
                                      });
                                      selectedvalue.add(companyname);
                                    });

                                    if(categorypopup=="Product"){

                                      String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                      String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                      sku(
                                          startDateFormatted,endDateFormatted,
                                          companyid.isEmpty ? [] : [companyid],
                                          categoryid.isEmpty ? [] : [categoryid],
                                          sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                          [],brandid.isEmpty ? [] : [brandid],[]
                                          ,selectedmeasures);
                                    }
                                    print('Selected Category: $selectedCategory');
                                  });},
                                child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: "Product_Brand_Name",
                                  code: "Product_Brand_Code"
                              ),
                            ),
                            ) ],
                      );

                  }):categorypopup=='Category'?
              ListView.builder(

                  itemCount: category.length,

                  shrinkWrap: true,

                  itemBuilder: (context, index) {
                    category.sort((a, b) {
                      String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
                      String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

                      double aSales = double.tryParse(aSalesStr) ?? 0;
                      double bSales = double.tryParse(bSalesStr) ?? 0;

                      // print('aSales: $aSales, bSales: $bSales');

                      return bSales.compareTo(aSales);
                    });
                    var item = category[index];




                    return

                      Column(
                        children: [
                          if(item['Sales_Inc_ST']!=null && ischeck==false )
                          Padding(

                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: (){

                                viewModel.category(context, (String category) {

                                  setState(() {
                                    categorypopup=category;
                                    categoryid=item["Product_Category_Code"].toString();
                                    categoryname=item['Product_Category_Name'].toString();
                                    //selectedCategories.add(category);
                                    selectedCategories.add({
                                      "category": category.toString(),
                                      "name": categoryname.toString(),
                                    });

                                    //  selectedCategories.add(companyname);


                                  });
                                  if(categorypopup=="Sub Category"){
                                    setState(() {
                                      brandid='';
                                      productid='';
                                    });

                                    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                    get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                        categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                                    //Navigator.pop(context);

                                  }
                                  if(categorypopup=="Brand"){

                                    setState(() {
                                      productid='';
                                    });
                                    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                    get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                        categoryid.isEmpty ? [] : [categoryid],
                                        sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                                    //Navigator.pop(context);

                                  }
                                  if(categorypopup=="Product"){


                                    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                    sku(
                                        startDateFormatted,endDateFormatted,
                                        companyid.isEmpty ? [] : [companyid],
                                        categoryid.isEmpty ? [] : [categoryid],
                                        sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                        [],brandid.isEmpty ? [] : [brandid],[]
                                        ,selectedmeasures);
                                    //Navigator.pop(context);

                                  }

                                  print('Selected Category: $selectedCategory');
                                });},
child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: "Product_Category_Name",
code: "Product_Category_Code"
),

                            ),
                          ),
                          if(ischeck==true )
                            Padding(

                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: (){

                                  viewModel.category(context, (String category) {

                                    setState(() {
                                      categorypopup=category;
                                      categoryid=item["Product_Category_Code"].toString();
                                      categoryname=item['Product_Category_Name'].toString();
                                      //selectedCategories.add(category);
                                      selectedCategories.add({
                                        "category": category.toString(),
                                        "name": categoryname.toString(),
                                      });

                                      //  selectedCategories.add(companyname);


                                    });
                                    if(categorypopup=="Sub Category"){
                                      setState(() {
                                        brandid='';
                                        productid='';
                                      });

                                      String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                      String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                      get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                                          categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                                      //Navigator.pop(context);

                                    }
                                    if(categorypopup=="Brand"){

                                      setState(() {
                                        productid='';
                                      });
                                      String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                      String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                      get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                          categoryid.isEmpty ? [] : [categoryid],
                                          sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                                      //Navigator.pop(context);

                                    }
                                    if(categorypopup=="Product"){


                                      String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                      String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                      sku(
                                          startDateFormatted,endDateFormatted,
                                          companyid.isEmpty ? [] : [companyid],
                                          categoryid.isEmpty ? [] : [categoryid],
                                          sub_categoryid.isEmpty ? [] : [sub_categoryid],

                                          [],brandid.isEmpty ? [] : [brandid],[]
                                          ,selectedmeasures);
                                      //Navigator.pop(context);

                                    }

                                    print('Selected Category: $selectedCategory');
                                  });},


                    child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: "Product_Category_Name",
                      code: "Product_Category_Code",),
                              ),
                            ),
                        ],
                      );

                  }):categorypopup=='Sub Category'?  ListView.builder(

                  itemCount: sub_category.length,

                  shrinkWrap: true,

                  itemBuilder: (context, index) {
                    sub_category.sort((a, b) {
                      String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
                      String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

                      double aSales = double.tryParse(aSalesStr) ?? 0;
                      double bSales = double.tryParse(bSalesStr) ?? 0;

                      // print('aSales: $aSales, bSales: $bSales');

                      return bSales.compareTo(aSales);
                    });
                    var item = sub_category[index];






                    return

                      Column(
                        children: [
                          if(item['Sales_Inc_ST']!=null && ischeck==false )
                          Padding(

                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: (){

                                viewModel.category(context, (String category) {

                                  setState(() {
                                    sub_categoryid=item["Product_SubCategory_Code"].toString();
                                    categorypopup=category;
                                    sub_categoryname=item["Product_SubCategory_Name"].toString();
                                    //selectedCategories.add(category);
                                    selectedCategories.add({
                                      "category": category.toString(),
                                      "name": sub_categoryname.toString(),
                                    });
                                  });
                                  if(categorypopup=="Product"){

                                    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                    sku(
                                        startDateFormatted,endDateFormatted,
                                        companyid.isEmpty ? [] : [companyid],
                                        categoryid.isEmpty ? [] : [categoryid],
                                        sub_categoryid.toString().isEmpty ? [] : [sub_categoryid.toString()],

                                        [],brandid.isEmpty ? [] : [brandid],[]
                                        ,selectedmeasures);
                                  }
                                  if(categorypopup=="Brand"){
                                    setState(() {
                                      productid='';
                                    });
                                    String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                    String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                    get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                        categoryid.isEmpty ? [] : [categoryid],
                                        sub_categoryid.toString().isEmpty ? [] : [sub_categoryid.toString()], [], [], [],selectedmeasures);
                                  }
                                  print('Selected Category: $selectedCategory');
                                });},
                              child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: 'Product_SubCategory_Name', code: "Product_SubCategory_Code",)
                            ),
                          ),
                          if(ischeck==true)
                            Padding(

                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: (){

                                  viewModel.category(context, (String category) {

                                    setState(() {
                                      sub_categoryid=item["Product_SubCategory_Code"].toString();
                                      categorypopup=category;
                                      sub_categoryname=item["Product_SubCategory_Name"].toString();
                                      //selectedCategories.add(category);
                                      selectedCategories.add({
                                        "category": category.toString(),
                                        "name": sub_categoryname.toString(),
                                      });
                                    });
                                    if(categorypopup=="Product"){

                                      String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                      String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                      sku(
                                          startDateFormatted,endDateFormatted,
                                          companyid.isEmpty ? [] : [companyid],
                                          categoryid.isEmpty ? [] : [categoryid],
                                          sub_categoryid.toString().isEmpty ? [] : [sub_categoryid.toString()],

                                          [],brandid.isEmpty ? [] : [brandid],[]
                                          ,selectedmeasures);
                                    }
                                    if(categorypopup=="Brand"){
                                      setState(() {
                                        productid='';
                                      });
                                      String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                                      String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
                                      get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                                          categoryid.isEmpty ? [] : [categoryid],
                                          sub_categoryid.toString().isEmpty ? [] : [sub_categoryid.toString()], [], [], [],selectedmeasures);
                                    }
                                    print('Selected Category: $selectedCategory');
                                  });},



                    child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: 'Product_SubCategory_Name',code:"Product_SubCategory_Code"),
                              ),
                            ),
                        ],
                      );


  }):categorypopup=='Product'?  ListView.builder(

  itemCount: skumodel.length,

  shrinkWrap: true,

  itemBuilder: (context, index) {
    skumodel.sort((a, b) {
      String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
      String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

      double aSales = double.tryParse(aSalesStr) ?? 0;
      double bSales = double.tryParse(bSalesStr) ?? 0;

      // print('aSales: $aSales, bSales: $bSales');

      return bSales.compareTo(aSales);
    });
  var item = skumodel[index];


  // itemBuilder callback is called for each item in the list

  return
Column(children: [
  if(item['Sales_Inc_ST']!=null && ischeck==false )
  Padding(

  padding: const EdgeInsets.all(4.0),
  child: InkWell(
  onTap: (){
  //sales.showLoadingDialog(context);
},

  child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: 'Product_Product_Name'),

  ),
  ),
  if(ischeck==true )
    Padding(

      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: (){
          //sales.showLoadingDialog(context);
        },

    child: ProductItem(item: item, selectedmeasures: selectedmeasures, index: index, name: 'Product_Product_Name'),

    ),
    )
],);

  })
            :Text(('no data')))
          ),

          //Spacer(),

          Visibility(
              visible: !showDateContainers && !company ,
              child: RoundButton(title: "Done", onPress: (){
                String startDateFormatted = DateFormat('yyyy,MM,dd').format(widget.startdate!);
                String endDateFormatted = DateFormat('yyyy,MM,dd').format(widget.enddate!);
    if (widget.startdate!.isBefore(widget.enddate!))
    {

                setState(() {

                  company=true;
                  !showDateContainers;

                                 if(widget.name=="PCP" &&  categorypopup=="") {
                  executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                }
                if(widget.name=="CONSUMER" &&  categorypopup=="") {
                  executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                }

                if(widget.name=="FMCG" &&  categorypopup=="") {
                  executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                }

                if(widget.name=="PHARMA" &&  categorypopup=="") {
                  executeApiCall(startDateFormatted,endDateFormatted,selectedmeasures);
                }
                  if(widget.name=="Company" && categorypopup=="") {
                    all(startDateFormatted, endDateFormatted,selectedmeasures);
                  }
                  if(widget.name=="Company" && categorypopup=="Category") {
                  get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                }
                  if(widget.name=="Company" && categorypopup=="Sub Category") {
                    get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="Company" && categorypopup=="Brand") {
                    get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="Company" && categorypopup=="Product") {
                    sku(
                        startDateFormatted,endDateFormatted,
                        companyid.isEmpty ? [] : [companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid],

                        [],brandid.isEmpty ? [] : [brandid],[]
                        ,selectedmeasures);
                  }
                  if(widget.name=="PCP" && categorypopup=="Category") {
                    get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                  }
                  if(widget.name=="PCP" && categorypopup=="Sub Category") {
                    get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="PCP" && categorypopup=="Brand") {
                    get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="PCP" && categorypopup=="Product") {
                    sku(
                        startDateFormatted,endDateFormatted,
                        companyid.isEmpty ? [] : [companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid],

                        [],brandid.isEmpty ? [] : [brandid],[]
                        ,selectedmeasures);
                  }
                  if(widget.name=="PHARMA" && categorypopup=="Category") {
                    get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                  }
                  if(widget.name=="PHARMA" && categorypopup=="Sub Category") {
                    get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="PHARMA" && categorypopup=="Brand") {
                    get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="PHARMA" && categorypopup=="Product") {
                    sku(
                        startDateFormatted,endDateFormatted,
                        companyid.isEmpty ? [] : [companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid],

                        [],brandid.isEmpty ? [] : [brandid],[]
                        ,selectedmeasures);
                  }
                  if(widget.name=="CONSUMER" && categorypopup=="Category") {
                    get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                  }
                  if(widget.name=="CONSUMER" && categorypopup=="Sub Category") {
                    get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="CONSUMER" && categorypopup=="Brand") {
                    get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="CONSUMER" && categorypopup=="Product") {
                    sku(
                        startDateFormatted,endDateFormatted,
                        companyid.isEmpty ? [] : [companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid],

                        [],brandid.isEmpty ? [] : [brandid],[]
                        ,selectedmeasures );
                  }
                  if(widget.name=="FMCG" && categorypopup=="Category") {
                    get_category(companyid.isEmpty ? [] :[companyid],startDateFormatted,endDateFormatted,selectedmeasures);
                  }
                  if(widget.name=="FMCG" && categorypopup=="Sub Category") {
                    get_sub_category(startDateFormatted,endDateFormatted,companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] :[categoryid], [], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="FMCG" && categorypopup=="Brand") {
                    get_division(startDateFormatted,endDateFormatted, companyid.isEmpty ? [] :[companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid], [], [], [],selectedmeasures);
                  }
                  if(widget.name=="FMCG" && categorypopup=="Product") {
                    sku(
                        startDateFormatted,endDateFormatted,
                        companyid.isEmpty ? [] : [companyid],
                        categoryid.isEmpty ? [] : [categoryid],
                        sub_categoryid.isEmpty ? [] : [sub_categoryid],

                        [],brandid.isEmpty ? [] : [brandid],[],selectedmeasures
                    );
                  }



                });}
              else
              {
                Utils.flushBarErrorMessage("Start date should be less then to End date", context);
                  }
              })
          ),




          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: isLoading ,
              child: CircularProgressIndicator(color: Colors.green[800],),
            ),
          ),
          calculated_sale(totalsale: "$formattedTotals"),
        ]
        ),

    );}}