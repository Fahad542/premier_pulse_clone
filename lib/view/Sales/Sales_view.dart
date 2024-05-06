import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/model/team_company.dart';
import 'package:mvvm/respository/sales_repository.dart';
import 'package:mvvm/utils/customs_widgets/calculated_sale.dart';
import 'package:mvvm/utils/customs_widgets/circle_avatar_index.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/Home/home_screen.dart';
import 'package:mvvm/view/login_view.dart';
import 'package:share/share.dart';
import '../../model/branch_model.dart';
import '../../model/heirarchy_model.dart';
import '../../model/sales_model.dart';
import '../../res/color.dart';
import '../../res/components/round_button.dart';
import '../../respository/measure_repository.dart';
import '../../utils/Drawer.dart';
import '../../utils/customs_widgets/dsf_measure_popup.dart';
import '../../utils/customs_widgets/list_filters.dart';
import '../../utils/customs_widgets/text_widget.dart';
import 'Date.dart';
import 'Sales_viewmodel.dart';
class SalesReport extends StatefulWidget {
  final String? data;
  SalesReport({ this.data});

  @override
  State<SalesReport> createState() => _SalesReportState();
}
final salesViewModel = SalesHeirarchyViewModel();
class _SalesReportState extends State<SalesReport> {
  // The empCode to initially show

  bool showInitialHierarchy = true;
  String reporting='${empcode.auth}';
 String Start='';
 String End='';
 bool ischeck=false;
  String empCodeSet='';
 bool donestring=false;
 bool setstring=false;
  String cleanedIds='';
  List<String> updateSelectedItems=[];
  String formattedTotals='';
  List<int> companynumbers=[];
  List<int> branchnumbers=[];
  List<String> concatenatedList = [];
  List<String> concatenatedListbranch = [];
  List<bool> checkcompany = [];
  List<bool> checkbranch = [];
  List<bool> checkcbranch = [];
  List<int> intCodes=[];
  List<String> selectedValues=[];
  List<String> selectedbranchValues=[];
  List<String> selectedmeasures=[];
  List<String> selectedValue=[];
  List<String> comapnycodelist=[];
  List<String> branchcodelist=[];
  final formatter = NumberFormat('#,###');
  List<String> companyname=[];
  List<String> comapnycodelistAsList=[];
  List<String> formattedString=[];
  List<String> concatenatedcode=[];
  String untaggedcode='All';
  List<String> untagged=[];
  @override
  void dispose() {

    if (mounted) {

      Navigator.of(context).pop();
    }
    super.dispose();
  }

  @override
  void initState() {

    final repository = measure_repository();
    repository.fetchDataAndSave();
    salesViewModel.refreshSelectedToAddbranch();
    super.initState();
    String nonNullableData = widget.data ?? reporting;
    _loadUserDetails(nonNullableData,'1');

    teamcompany();
    branchcompany();

  }

  String empCodeString = '';
  Future<void> branchcompany() async {

    await salesViewModel.initializeDatabase();
    final data = await salesViewModel.fetchbranchdata();


    setState(() {
      branch=data;
      for (final item in branch) {

        final String id = item.BranchID.toString();
        final String name = item.BranchName;
        final bool check=item.ischecked;
        print("check$check - name:$name");

        String concatenatedString =
            "${item.BranchName} - ${item.BranchID}";
        concatenatedListbranch.add(concatenatedString);
        checkbranch.add(item.ischecked);

      }});
    print("checkbranch :$checkbranch");
  }
  Future<void> teamcompany() async {

    await salesViewModel.initializeDatabase();
    final data = await salesViewModel.fetchdata();
     untaggedcode = await salesViewModel.untaggedCode();

    setState(() {
      team=data;
      for (final item in team) {

        final String id = item.companyID;
        final String name = item.companyName;
        //final bool companycheck =item.ischecked==false;
        //final bool ischeck=item. ;

       // print('company: $companycheck - $name');
        //print('name: $id');
        String concatenatedString =
            "${item.companyID} - ${item.companyName}";
        concatenatedList.add(concatenatedString);
        concatenatedcode.add(item.companyName);
        checkcompany.add(item.ischecked);
      }});
  }


  Future<void> _loadUserDetails(String reporting, String repto) async {
    empCodeString='';
     userDetailsList.clear();
    await salesViewModel.initializeDatabase();
    final data = await salesViewModel.select(reporting,repto);
    setState(() {
      userDetailsList = data;
      for (final item in userDetailsList) {

        final String id = item.empCode;
        final String name = item.empName;

        checkboxStates[id] = item.isCheck;

        setState(() {
          // Add a comma if empCodeString is not empty
          if (empCodeString.isNotEmpty) {
            empCodeString += ',';
          }
          if(name.trim()=="Utagged")
            {

              untagged = ["All"];
            }
         else {
            empCodeString += id;
            untagged.clear();
          }
          print('${id}');
        });
      }

      if (empCodeString.isNotEmpty) {
        // Split empCodeString into a list of individual employee codes
        String empCodeList = '';

        // Convert the list to a Set to remove duplicates (if any)
         empCodeSet = empCodeList;

    }

    });

  }

String total='0';
  int totals=0;
  List<UserDetails> userDetailsList = [];
  List<Team_compnay> team = [];
  List<Branch_compnay> branch = [];
  List<SalesData> SalesList = [];
  //late Future<List<SalesData>> salesDataFuture;
  List<UserDetails> stackItems = [];
  bool showLoading = false;
  bool customer =false;
  String sharedata='';
  List<SalesData> salesstackItems = [];
 var apiResponseList ;
  List<SalesData> updatedList =[];
  List<SalesData> back =[];
  var companylist;
  List<SalesData> dateschange =[];
  Map<String, bool> checkboxStates = {};
  bool heirarchycheck=false;
  Set<String> selectedIds={};
  Set<String> selected = {};
  DateTime? startDate= DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? endDate= DateTime.now();
  String name='';
  String id='';
  String sale='0';
  //int index=1;
  String combinedMessage='';

  bool isFirstClick = true;
  bool showsales = false;
  bool showChildren = true;
  bool _selectAllChecked = false;
  void setChildrenCheckboxStatesToFalse(String parentId) {
    for (final childItem
    in userDetailsList.where((item) => item.reportingTo == 1))

    {
      final String id = childItem.empCode;
      //final String reporting_to = childItem.reportingTo;
      checkboxStates[id] = false;
      final int index = userDetailsList.indexOf(childItem);
      // setState(() {
      //   //checkboxStates[id] = false;
      // });
      setChildrenCheckboxStatesToFalse(id);
    }
  }

  bool isCheckboxSelected = false;
  bool done = false;
  bool showDateContainers = false;

  void resetSelectedCheckboxes() {
    for (final id in selectedIds) {
      checkboxStates[id] = false;
    }
    selectedIds.clear();
    setState(() {
      done = false;
    });
  }
  void checkAllCheckboxes() {
    setState(() {
      _selectAllChecked = !_selectAllChecked;

      for (final item in userDetailsList) {
        final String id = item.empCode;
        final String ename = item.empName;
        checkboxStates[id] = _selectAllChecked;

        // Add condition to check if id is equal to 2712

        print(id);
        if (_selectAllChecked && ename.trim()!='Utagged' ) {
          selectedIds.add(id);
        } else {
          selectedIds.remove(id);
        }
      }


      done = _selectAllChecked;
      isCheckboxSelected = _selectAllChecked;

    });
  }


  List<String> getMatchingEmpCodes(String parentId) {
    final matchingEmpCodes = userDetailsList
    //.where((item) => item.empCode == parentId)
        .map<String>((childItem) => childItem.empName)
        .toList();

    return matchingEmpCodes;
  }

  Widget buildHierarchyTree() {
    bool anyChildChecked = false;
    final selectedItems = <Widget>[];

    final heirarchy = userDetailsList
    //.where((item) => item.reportingTo == parentId && item.reportingTo != item.empCode)

        .map<Widget>((childItem) {
      setState(() {
        //index=index+1;
        final int index = userDetailsList.indexOf(childItem);
      });
      final String id = childItem.empCode;
      final String name = childItem.empName;
      final String reportingto = childItem.reportingTo;
      bool isChecked = checkboxStates[id] ?? false;
      if (isChecked) {
        anyChildChecked = true;
        selectedItems.add(
          Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.green,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(childItem.empName),
                ),
              ],
            ),
          ),
        );
      }
      return
        ListTile(
          title: InkWell(
            onTap: () {
              setState(() {
                stackItems.add(UserDetails(
                  empName: childItem.empName,
                  empCode: childItem.empCode,
                  reportingTo: childItem.reportingTo,
                  designation: childItem.designation,
                  isCheck: false,
                ));
                _loadUserDetails(id, reportingto);
                setChildrenCheckboxStatesToFalse(id);
                bool anyCheckboxSelected = checkboxStates.containsValue(true);
                isCheckboxSelected = anyCheckboxSelected;
                setState(() {
                  done = false;
                });
              });
              resetSelectedCheckboxes();
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color:  AppColors.ligthgreenshade,
                boxShadow: [
                  // BoxShadow(
                  //   color: AppColors.ligthgreen.withOpacity(0.2),
                  //   blurRadius: 1,
                  //   offset: Offset(0, 2),
                  // ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [


                              Row(

                                children: [
                                  Circle_avater(index: userDetailsList.indexOf(
                                      childItem) + 1),
                                  SizedBox(width: 5,),
                                  Text("${childItem.empName} ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),

                                  ),
                                  Text(
                                    childItem.empName == 'Utagged'
                                        ? ''
                                        : "${childItem.empCode}",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${"Designation: ${childItem.designation}"}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color:AppColors.greencolor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  if(childItem.designation!="DSF")
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child:
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          // Only allow checking if the checkbox is currently unchecked
                          if (value!) {
                            // Uncheck all other checkboxes in the list
                            checkboxStates.updateAll((key, _) => false);
                            // Check the current checkbox
                            checkboxStates[id] = true;

                            // Update selectedIds to contain only the ID of the current checkbox
                            selectedIds = [id].toSet();


                            // Perform any other actions needed when a checkbox is checked
                            if (name.trim() == 'Utagged') {
                              untagged = ["All"];
                            } else {
                              untagged.clear();
                            }
                            print(name);
                          } else {
                            // Allow unchecking the checkbox
                            checkboxStates[id] = false;
                            selectedIds.remove(id);
                          }

                          // Update the 'done' flag based on checkbox states
                          done = checkboxStates.containsValue(true);

                          // Update the 'isCheckboxSelected' flag
                          isCheckboxSelected = checkboxStates.containsValue(true);
                        });
                      },
                      activeColor: AppColors.greencolor,
                      checkColor: Colors.white,
                      hoverColor: Colors.yellow,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),

                  ),
                ],
              ),
            ),
          ),
        );
    }).toList();

    DateFormat dateFormat = DateFormat('yyyy,MM,dd');
    String formattedStartDate = dateFormat.format(startDate ?? DateTime.now());
    String formattedEndDate = dateFormat.format(endDate ?? DateTime.now());

    if (showsales) {
      return apiResponseList != null && apiResponseList.isNotEmpty
          ?
      ListView.builder(
       scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: apiResponseList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          apiResponseList.sort((a, b) {
            String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
            String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
            double aSales = double.tryParse(aSalesStr) ?? 0;
            double bSales = double.tryParse(bSalesStr) ?? 0;
            return bSales.compareTo(aSales);
          });
          final salesData = apiResponseList[index];

          return

            Column(
              children: [


                if(salesData['Sales_Inc_ST']!=null && ischeck==false)
                Padding
                  (
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                            onTap: () async
                            {
                              if (salesData['Sales_Inc_ST'].toString().isEmpty) {
                                Utils.flushBarErrorMessage("No Sale Found",
                                    context);
                              }
                              salesViewModel.showLoadingDialog(context);
                              try {
                                await _loadUserDetails(
                                 salesData['EmpCode'] ,'0',
                                );


                                if (empCodeString
                                    .trim()
                                    .isEmpty && salesData['Sales_Inc_ST'].toString().isNotEmpty) {
                                  if (salesViewModel != null) {
                                    Future.delayed(
                                        Duration(milliseconds: 500), () {
                                      salesViewModel.showCustomerWiseDialog(
                                          context,
                                      salesData['EmpCode'] , formattedStartDate,
                                          formattedEndDate, salesData['EmpName'],
                                          companynumbers,
                                          branchnumbers,
                                      selectedmeasures);
                                    });
                                  }

                                  return;
                                }

                                if (salesData['Sales_Inc_ST'].toString().isNotEmpty) {
                                  setState(() {
                                    cleanedIds =    salesData['EmpCode'].toString().toString().replaceAll('{', '').replaceAll('}', '');
                                    selectedIds = cleanedIds.split(',').toSet();

                                  });
                                  print('Cleanids:$cleanedIds');
                                  apiResponseList =
                                  await SalesRepository().fetchData(
                                      cleanedIds,
                                      formattedStartDate,
                                      formattedEndDate,
                                      companynumbers,
                                      branchnumbers,
                                    selectedmeasures
                                  );
                                }
                                setState(() {
                                  donestring = false;
                                });
                                setstring = true;

                                if (salesData['Sales_Inc_ST'].toString().isNotEmpty) {
                                  setState(() {
                                    stackItems.add(UserDetails(
                                      empName: salesData['EmpName'],
                                      empCode: salesData['EmpCode'],
                                      reportingTo: "",
                                      designation: salesData['EmpDesignation'],
                                      isCheck: false,
                                    ));
                                    apiResponseList = apiResponseList;
                                  });
                                }


                                setState(() {
                                  totals=0;
                                  for (int i = 0; i < apiResponseList.length; i++) {
                                        double salesValue = apiResponseList[i]['Sales_Inc_ST'] ?? 0;
                                        totals += salesValue.round(); // Round off salesValue and add it to totals

                                      formattedTotals = formatter.format(totals); // Format totals with commas

                                    //int sum = apiResponseList[i].sales.reduce((value, element) => value + element);


                                    if (apiResponseList[i]['EmpCode']
                                        .isNotEmpty) {
                                      name = apiResponseList[i]['EmpName'];
                                      id = apiResponseList[i]['EmpCode']
                                          .toString();
                                      sale =
                                          apiResponseList[i]['Sales_Inc_ST'].toString();
                                    }
                                  }
                                });
                              }
                              catch (error) {
                                // Handle the exception here

                                print('Error: $error');
                                Utils.snackBarred(
                                    "Error to load data", context);
                              }
                              finally {
                                Navigator.of(context)
                                    .pop(); // Close the loading dialog regardless of success or failure
                              }
                            },
                            child:

                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  //if(salesData['EmpDesignation']=="DSF")
                                    ProductItem(
                                      empcheck: true,
                                      item: salesData,
                                      selectedmeasures: selectedmeasures,
                                      index: index,
                                      name: 'EmpName',
                                      code: "EmpCode",
                                      checkdsf: true,
                                      onTap: () {
                                        print("object");
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DSFMeasurePopup(startDate: formattedStartDate, endDate: formattedEndDate, dsfCode: salesData['EmpCode']);
                                          },
                                        );
                                      },
                                    ),
                                // ProductItem(item: salesData, selectedmeasures: selectedmeasures, index: index, name: 'EmpName',code:"EmpCode"),

                                ],
                              ),
                            )


                        ))),
                if(ischeck==true)
                  Padding
                    (
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                              onTap: () async
                              {
                                if (salesData['Sales_Inc_ST'].toString().isEmpty) {
                                  Utils.flushBarErrorMessage("No Sale Found",
                                      context);
                                }
                                salesViewModel.showLoadingDialog(context);
                                try {
                                  await _loadUserDetails(
                                    salesData['EmpCode'] ,'0',
                                  );


                                  if (empCodeString
                                      .trim()
                                      .isEmpty && salesData['Sales_Inc_ST'].toString().isNotEmpty) {
                                    if (salesViewModel != null) {
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        salesViewModel.showCustomerWiseDialog(
                                            context,
                                            salesData['EmpCode'] , formattedStartDate,
                                            formattedEndDate, salesData['EmpName'],
                                            companynumbers,
                                            branchnumbers,
                                            selectedmeasures);
                                      });
                                    }

                                    return;
                                  }

                                  if (salesData['Sales_Inc_ST'].toString().isNotEmpty) {
                                    setState(() {
                                      cleanedIds =    salesData['EmpCode'].toString().toString().replaceAll('{', '').replaceAll('}', '');
                                      selectedIds = cleanedIds.split(',').toSet();

                                    });
                                    print('Cleanids:$cleanedIds');
                                    apiResponseList =
                                    await SalesRepository().fetchData(
                                        cleanedIds,
                                        formattedStartDate,
                                        formattedEndDate,
                                        companynumbers,
                                        branchnumbers,
                                        selectedmeasures
                                    );
                                  }
                                  setState(() {
                                    donestring = false;
                                  });
                                  setstring = true;

                                  if (salesData['Sales_Inc_ST'].toString().isNotEmpty) {
                                    setState(() {
                                      stackItems.add(UserDetails(
                                        empName: salesData['EmpName'],
                                        empCode: salesData['EmpCode'],
                                        reportingTo: "",
                                        designation: salesData['EmpDesignation'],
                                        isCheck: false,
                                      ));
                                      apiResponseList = apiResponseList;
                                    });
                                  }


                                  setState(() {
                                    totals=0;
                                    for (int i = 0; i < apiResponseList.length; i++) {

                                      // Assuming apiResponseList[i].sales is a numeric value
                                      double salesValue = apiResponseList[i]['Sales_Inc_ST'] ?? 0;
                                      totals += salesValue.round(); // Round off salesValue and add it to totals

                                      formattedTotals = formatter.format(totals); // Format totals with commas

                                      if (apiResponseList[i]['EmpCode']
                                          .isNotEmpty) {
                                        name = apiResponseList[i]['EmpName'];
                                        id = apiResponseList[i]['EmpCode']
                                            .toString();
                                        sale =
                                            apiResponseList[i]['Sales_Inc_ST'].toString();
                                      }
                                    }
                                  });
                                }
                                catch (error) {
                                  // Handle the exception here

                                  print('Error: $error');
                                  Utils.snackBarred(
                                      "Error to load data", context);
                                }
                                finally {
                                  Navigator.of(context)
                                      .pop(); // Close the loading dialog regardless of success or failure
                                }
                              },
                              child:

                              Padding(

                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      ProductItem(
                                        empcheck: true,
                                        item: salesData,
                                        selectedmeasures: selectedmeasures,
                                        index: index,
                                        name: 'EmpName',
                                        code: "EmpCode",
                                        checkdsf: true,
                                        onTap: () {
                                          print("object");
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DSFMeasurePopup(startDate: formattedStartDate, endDate: formattedEndDate, dsfCode: salesData['EmpCode']);
                                            },
                                          );

                                        },
                                      ),
                                  ],
                                ),
                              )


                          )))







          ],

            );
        },
      )

          : Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child:

            Text("Error to load data",
              style: TextStyle(color: Colors.green[800]),),
          )
      );
    }
    if (heirarchy.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Text(
            "No Sub Level Employee Available",
            style: TextStyle(color: AppColors.ligthgreen, fontSize: 20),
          ),
        ),
      );
    }

    if (!anyChildChecked) {
      done = false;
    }



      return

        Column(

          children: heirarchy,

        );
    }

  void showLoadingIndicator() {
    setState(() {
      showLoading = true;
    });
  }

  void hideLoadingIndicator() {
    setState(() {
      showLoading = false;
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Set<String> modifiedSet;
    String formattedStartDate='';
    String  formattedEndDate='';
    void showfitler() async {

      await salesViewModel.initializeDatabase();
      await salesViewModel.fetchdata();
      await salesViewModel.fetchbranchdata();
      setState(() {
        try {

          salesViewModel.showDropdownCheckboxs(
            context,
            concatenatedListbranch,
            concatenatedList,
            selectedValue,
            "Select Companies",
            checkcompany,
            checkbranch,
                (selectedValue) {
              comapnycodelist = selectedValue;
              print('Selected Values: $checkbranch');
            },
                (selectedValue) {
              branchcodelist = selectedValue;

              print('Selected Values: $branchcodelist');
            },

                () async {
              try {
                salesViewModel.showLoadingDialog(context);

                Set<String> idSet = Set<String>();
                setState(() {
                  for (int i = 0; i < apiResponseList.length; i++) {
                    double salesValue = apiResponseList[i]['Sales_Inc_ST'] ?? 0;
                    totals += salesValue.round(); // Round off salesValue and add it to totals

                    formattedTotals = formatter.format(totals);
                  } });
                DateFormat dateFormat = DateFormat('yyyy,MM,dd');
                formattedStartDate = dateFormat.format(startDate!);
                formattedEndDate = dateFormat.format(endDate!);
                //String ids = selectedIds.toString().replaceAll('{', '').replaceAll('}', '');
                branchnumbers = branchcodelist.map((part) => int.parse(part.replaceAll('"', ''))).toList();
                companynumbers = comapnycodelist.map((code) => int.parse(code)).toList();
                //onDone(intCodes);
                companylist = await SalesRepository().fetchData(
                    cleanedIds,
                    formattedStartDate,
                    formattedEndDate,
                    companynumbers,
                    branchnumbers,
                  selectedmeasures
                );
                setState(
                        () {
                      totals=0;
                      for (int i = 0; i < companylist.length; i++) {
                          double salesValue = companylist[i]['Sales_Inc_ST'] ?? 0;
                          totals += salesValue.round(); // Round off salesValue and add it to totals

                        formattedTotals = formatter.format(totals);

                      }
                      apiResponseList=companylist;
                    }
                );

                Navigator.of(context).pop();
              } catch (error) {
                // Handle API call error
                print('API Error: $error');
                Utils.snackBarred("Error to load data", context);
                Navigator.of(context).pop(); // Close loading dialog

              }
            },

          );
        } catch (error) {
          // Handle UI/dialogue box error
          print('UI Error: $error');
        }
      });

    }
    // bool showDateContainers = false;



    return  WillPopScope(
        onWillPop: () async {

      return false;
    },
    child:Scaffold(
      key: scaffoldKey1,
      appBar: AppBar(
        title: Text('States Report'),
        backgroundColor: AppColors.greencolor,
        actions: [

          Visibility(
            visible: showsales,
            child: Container(
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.greencolor,
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
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.greencolor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.calendar_today, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 6),
                          Text(showDateContainers ? 'Dates Hide' : 'Dates Show', style: TextStyle(fontSize: 14)),
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
                              color: AppColors.greencolor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.filter_list, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 6),
                          Text('Measures', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 6),

                        ],
                      ),
                      value: 'Measures',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.greencolor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.filter_list, color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 6),
                          Text('Filters', style: TextStyle(fontSize: 14)),
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
                              color: AppColors.greencolor,
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
                  BuildContext currentContext = context;


                  // Handle menu item selection here
                  if (value == 'Measures') {
                    try {

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return filters(
                            onSelectionDone: (selectedValues) async {
                              setState(() {
                                selectedmeasures = selectedValues.toList();
                              });
                              salesViewModel.showLoadingDialog(context);
                              DateFormat dateFormat = DateFormat('yyyy,MM,dd');
                              formattedStartDate = dateFormat.format(startDate!);
                              formattedEndDate = dateFormat.format(endDate!);
                              apiResponseList = await SalesRepository().fetchData(
                                cleanedIds.toString(),
                                formattedStartDate,
                                formattedEndDate,
                                companynumbers,
                                branchnumbers,
                                selectedmeasures,
                              );
                              setState(() {
                                apiResponseList = apiResponseList;
                              });
                              Navigator.of(currentContext).pop();
                              // dialogCompleter.complete();

                              // Use selectedValues here
                            },

                            selectedvalues: selectedmeasures,

                          );

                        },

                      );

                      //Navigator.of(context).pop();
                    } catch (e) {
                      Navigator.of(currentContext).pop();
                      print('An error occurred: $e');
                      // Handle the error here
                    }
                  }

                  if (value == 'share') {
                    String combinedMessage = '';

                    combinedMessage += "Start Date: $formattedFirstDay\nEnd Date: $formattedLastDay\n\n";

                    for (int i = 0; i < apiResponseList.length; i++) {
                      if (apiResponseList[i]['EmpCode'].isNotEmpty) {
                        String name = apiResponseList[i]['EmpName'];
                        String id = apiResponseList[i]['EmpCode'].toString();

                        String sale = NumberFormat('#,###').format(double.parse(apiResponseList[i]['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0'));
                        sale = sale.isEmpty ? '0' : sale;

                        String measure = ''; // Reset measure for each iteration

                        measure += List.generate(
                          selectedmeasures.length,
                              (index) {
                            final measure = selectedmeasures[index];
                            final teamValue = apiResponseList[i][measure.toString().replaceAll(' ', '_')];
                            final formattedValue = teamValue != null ? (measure.endsWith('%') ? teamValue.toString() : formatter.format(teamValue).toString()) : '0';
                            return "$measure: $formattedValue";
                          },
                        ).join('\n');

                        combinedMessage += "Name: $name\nID: $id\nSale: $sale\n$measure\n\n";
                      }
                    }

                    Share.share(combinedMessage, subject: 'Sales Information');
                  }


                  if (value == 'date') {
                    setState(() {
                      done = !done;
                      showDateContainers = !showDateContainers;
                    });
                  }
                  if (value == 'filters') {
                    showfitler();
                  }
                  if (value == 'sales') {
                    setState(() {
                      ischeck = !ischeck;
                    });
                  } else {
                    print('Selected: $value');
                  }
                },
              ),
            ),
          ),


        ],


        leading: Builder(
          builder: (BuildContext context) {
            return Container(

                margin:  EdgeInsets.all(8),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    // Black color with 50% opacity
                    spreadRadius: 1,
                    // Spread radius
                    blurRadius: 2,
                    // Blur radius
                    offset: Offset(0, 3), // Offset in x and y direction
                  ),
                ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,),

                child: Center(child: IconButton(
                  icon: Icon(
                    // Change this to the desired icon for the CustomDrawer
                      Icons.menu, // Change 'menu' to the desired icon
                      color: AppColors.ligthgreen
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                ));
          },
        ),
      ),
      drawer: CustomDrawer(),

      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.greencolor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: ()  async {



                      setState(()  {
                        customer=false;
                        showChildren = true;
                        _loadUserDetails(reporting,'1');
                        stackItems.clear();
                        totals=0;
                        for (final id in checkboxStates.keys) {
                          checkboxStates[id] = false;
                        }
                        isCheckboxSelected = false;
                        showsales = false;
                        done = false;
                        resetSelectedCheckboxes();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0),
                      decoration: BoxDecoration(color: Colors.red,
                          borderRadius: BorderRadius.circular(16)),

                      child:
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: const Text(
                          'Root: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: stackItems
                              .asMap()
                              .map((index, stackItem) {
                            final stackItemTitle = UserDetails(
                                empName: stackItem.empName,
                                empCode: stackItem.empCode,
                                reportingTo: stackItem.reportingTo,
                                designation: stackItem.designation,
                                isCheck: false
                            ).empName;
                            final stackItemdes = UserDetails(
                                empName: stackItem.empName,
                                empCode: stackItem.empCode,
                                reportingTo: stackItem.reportingTo,
                                designation: stackItem.designation,
                                isCheck: false
                            ).designation;

                            return MapEntry(
                              index,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                  decoration: BoxDecoration(
                                    color: index == stackItems.length - 1
                                        ? AppColors.ligthgreenshade
                                        : Colors.white,
                                    border: Border.all(
                                      color: index == stackItems.length - 1
                                          ? AppColors.ligthgreenshade
                                          : Colors.white,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        index == stackItems.length - 1
                                            ? Colors.black54
                                            : Colors.black45,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GestureDetector(

                                    onTap: ()  async {
                                      setState(() {
                                        apiResponseList = back;
                                      });
                                      _loadUserDetails(stackItem.empCode,stackItem.reportingTo
                                          );
                                      setState(() {

                                      total;
                                        // _loadUserDetails(stackItemTitle);
                                        // print(stackItemTitle);
                                        for (int i = index + 1;
                                        i < stackItems.length;
                                        i++) {
                                          final idToRemove =
                                              stackItem.empCode;
                                          checkboxStates[idToRemove] =
                                          false;

                                          //print(stackItem.empCode);
                                        }

                                        stackItems.removeRange(
                                            index + 1, stackItems.length);
                                        done = false;
                                        //print(stackItem);
                                        showsales = false;

                                      });
                                      resetSelectedCheckboxes();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(

                                        children: [
                                          Text(
                                            stackItemTitle,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight:
                                              index == stackItems.length - 1
                                                  ? FontWeight.w600 : FontWeight
                                                  .normal,

                                              color:
                                              index == stackItems.length - 1
                                                  ? Colors.black
                                                  : Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text('Designation: $stackItemdes', style: TextStyle(fontSize: 8, color: AppColors.greencolor, fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                              .values
                              .toList().reversed.toList(),


                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        if(showsales)
          Container(
            decoration: BoxDecoration( color: AppColors.ligthgreenshade,
              borderRadius: BorderRadius.only( bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),),
            ),
            child:   Padding(
              padding: const EdgeInsets.all(10.0),
              child:   Column(
                children: [
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      //SizedBox(width: 10,),
                       Text("Name",style: TextStyle(color: AppColors.greencolor, fontSize: 16, fontWeight: FontWeight.bold ),),
                      Text("Sales",  style: TextStyle(color:AppColors.greencolor, fontSize: 16, fontWeight: FontWeight.bold ),),



                    ],),

                ],
              ),


            ),
          ),



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: DateContainer(
                    title: "Start Date",
                    range: "yyyy-MM-dd",
                    selectedDate: startDate,
                    isVisible: showDateContainers,
                    onDateSelected: (date) {
                      setState(() {
                        startDate = date;
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
                    selectedDate: endDate,
                    isVisible: showDateContainers,
                    onDateSelected: (date) async {
                      setState(() {

                        endDate = date;

                      }


                      );

                    },

                  ),
                ),
              ],
            ),
          ),
          if(showsales)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Start Date: ${startDate.toString().split(' ')[0]} ", style: TextStyle(color: AppColors.greencolor,fontWeight: FontWeight.bold),), // Display only the date part
                  Text("End Date: ${endDate.toString().split(' ')[0]}", style: TextStyle(color: AppColors.greencolor,fontWeight: FontWeight.bold)), // Display only the date part
                ],
              ),
            ),
          if(showsales)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: Colors.green[800],),
            )   ,
          Expanded(

            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              children: [
                // Only show the initial hierarchy if the flag is set

                buildHierarchyTree(),              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Visibility(
                  visible: done && !showLoading,
                  // Only show if done is true and loading is false
                  child: RoundButton(
                    title: "Done",
                    onPress: () async {
                      if (startDate == null && endDate == null) {
                        setState(() {
                          Utils.flushBarErrorMessage(
                              'Please Select Dates', context);
                          showDateContainers = true;
                        });

                        if (isFirstClick) {
                          isFirstClick = false;
                        }
                      }
                      else {
                        if (startDate != null && endDate != null) {
                          if (startDate!.isBefore(endDate!) ||
                              startDate!.isAtSameMomentAs(endDate!)) {
                            DateFormat dateFormat = DateFormat('yyyy,MM,dd');
                             formattedStartDate = dateFormat.format(
                                startDate!);
                             formattedEndDate = dateFormat.format(
                                endDate!);
                            var connectivityResult = await Connectivity()
                                .checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              // No internet connection, show a snackbar or handle accordingly
                              Utils.snackBarred(
                                  'No Internet Connection', context);
                              setState(() {
                                checkboxStates.clear();
                              });

                              return;
                            }
                            try {
                              setState(() {
                                showLoading = true;
                              });
                              if (selectedIds.any((element) =>
                              element == null)) {
                                // Handle the case where an element is null, e.g., show an error message
                                print(
                                    'Error: selectedIds contains null elements');
                              } else {


                              modifiedSet = selectedIds.map((
                                    string) => '$string').toSet();
                                showDateContainers = false;
                              //Set<int> selectedIds = {999850};
                              String cleanedId = selectedIds.toString().replaceAll('{', '').replaceAll('}', '');
                              //print(cleanedIds); // Output: 999850
                                setState(() {
                                  cleanedIds=cleanedId;
                                });
                              apiResponseList =
                                await SalesRepository().fetchData(
                                    cleanedIds.toString(),
                                    formattedStartDate,
                                    formattedEndDate,
                                    companynumbers,
                                    branchnumbers,
                                  selectedmeasures
                                );

                              donestring=true;
                              setState(() {
                                totals = 0;
                                for (int i = 0; i < apiResponseList.length; i++) {
                                  // Assuming apiResponseList[i].sales is a numeric value
                                  double salesValue = apiResponseList[i]['Sales_Inc_ST'] ?? 0;
                                  totals += salesValue.round(); // Round off salesValue and add it to totals
                                }
                                formattedTotals = formatter.format(totals); // Format totals with commas
                              });

                              setState(() {
                                  showDateContainers = false;
                                });
                              }
                            } catch (e) {
                              Utils.snackBarred("Error to load data", context);
                              print('Error fetching data: $e');
                            } finally {
                              setState(() {
                                showLoading = false;
                              });
                            }

                            setState(() {
                              done = false;
                              showsales = true;
                            });
                          } else {
                            Utils.flushBarErrorMessage(
                                'Start date should be less than the end date',
                                context);
                          }
                        } else {
                          Utils.flushBarErrorMessage(
                              'Both start date and end date must be selected',
                              context);
                        }
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: showLoading,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: AppColors.ligthgreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(showsales)

        calculated_sale(

            totalsale: formattedTotals
        ),

        ],
      ),


    ));
  }}