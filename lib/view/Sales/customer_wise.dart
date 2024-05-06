

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/respository/customer_wise_repository.dart';
import 'package:mvvm/utils/customs_widgets/calculated_sale.dart';
import 'package:mvvm/utils/customs_widgets/dsf_level_heirarchy.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/Sales/Date.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/customer_wise_model.dart';
import '../../utils/customs_widgets/list_filters.dart';
import '../../utils/customs_widgets/text_widget.dart';
import '../../utils/datefixed_containers.dart';
import 'customer_compnay_view.dart';
enum SortOptions { Select, byAscendingName, byDecendingName, byMaximumSale, byMinimumSale }
class customer_wise extends StatefulWidget {
  final String empCode;
  final String startDate;
  final String endDate;
  final String name;
  final List<int>  companylist;
  final List<int>  branchlist;
  late List<String> selectedmeasures;

   customer_wise(String emp_code, String startdate, String enddate, {Key? key, required this.empCode, required this.startDate, required this.endDate, required this.name, required this.companylist, required this.branchlist, required this.selectedmeasures}) : super(key: key);

  @override
  State<customer_wise> createState() => _customer_wiseState();
}

bool isAscending=false;
bool calender=false;
bool ischeck=false;
DateTime? Start;
double totalSales = 0.0;
DateTime?  End;
List<String> measuresList=[];
String formattedStartDate='';
String formattedEndDate='';


  var storedata; // Initialize the list

class _customer_wiseState extends State<customer_wise> {

  String sale = '';
  SortOptions selectedSortOption = SortOptions.Select;
 var  originalStoredata ;

  void select(BuildContext context) {
    SortOptions? selected = SortOptions.Select;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[800],
          title: Text(
            'Sort Options',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: DropdownButton<SortOptions>(
              value: selectedSortOption,
              onChanged: (SortOptions? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedSortOption = newValue;
                    Navigator.of(context).pop();
                   // sortCustomers();
                  });
                } else {
                  setState(() {
                    storedata = List.of(originalStoredata);
                  });
                }
              },
              items: [
                buildDropdownItem(
                  SortOptions.Select,
                  'Select Sort',
                ),
                buildDropdownItem(
                  SortOptions.byAscendingName,
                  'Sort by Name in Ascending order',
                ),
                buildDropdownItem(
                  SortOptions.byDecendingName,
                  'Sort by Name in Descending order',
                ),
                buildDropdownItem(
                  SortOptions.byMaximumSale,
                  'Sort by Minimum to Maximum Sale',
                ),
                buildDropdownItem(
                  SortOptions.byMinimumSale,
                  'Sort by Maximum to Minimum Sale',
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  DropdownMenuItem<SortOptions> buildDropdownItem(
      SortOptions value,
      String label,
      ) {
    return DropdownMenuItem(
      value: value,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.green[800],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }

   var customerDataFuture;
  var storedata;
  var store;
  String total='0';
  bool calender=false;
  @override
  void initState() {
    super.initState();
    totalSales=0;
    isAscending = false;
    customerDataFuture = customerRepository().customer_wise_fetchData(widget.empCode,
        widget.startDate,
        widget.endDate,

    widget.companylist,widget.branchlist,widget.selectedmeasures
    );
    customerDataFuture.then((data) {
      setState(() {
        storedata = data;
        print(data);
        for(int i = 0; i < data.length; i++) {
          if (data[i]['Sales_Inc_ST'] != null) {
            totalSales += data[i]['Sales_Inc_ST'];
          }
        }
        originalStoredata = List.of(data);
      });

    });
    print("total: $total");

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
        Text('${widget.name}'),

        actions:[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                // PopupMenuItem(
                //   child: Row(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.all(6),
                //         decoration: BoxDecoration(
                //           color: Colors.green[800],
                //           borderRadius: BorderRadius.circular(6),
                //         ),
                //         child: Icon(Icons.sort, color: Colors.white, size: 18),
                //       ),
                //       SizedBox(width: 6),
                //       Text('Sort', style: TextStyle(fontSize: 14)),
                //     ],
                //   ),
                //   value: 'Sort',
                // ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(Icons.calendar_today, color: Colors.white, size: 18),
                      ),
                      SizedBox(width: 6),
                      Text(calender ? 'Dates off' : 'Dates', style: TextStyle(fontSize: 14)),
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
              // Handle menu item selection here
              if (value == 'Sort') {
                // Combine the information into a single text message
                String combinedMessage = ''; // Initialize the combined message outside the loop
setState(() {
  select(context);
});

                Share.share(combinedMessage, subject: 'Sales Information');
              }
              if (value == 'date') {
                setState(() {

                  calender = !calender;
                });
              }
              if (value == 'Measures') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return filters(
                      onSelectionDone: (selectedValues) {
                        setState(() {
                          widget.selectedmeasures =selectedValues.toList();
                        });
                        // Use selectedValues her
                      },
                      selectedvalues: widget.selectedmeasures,
                    );

                  },
                );
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

        ],

        backgroundColor: Colors.green[800],
      ),
      body: Column(
          children: [


Container(
  decoration: BoxDecoration( color: Colors.green.shade100,
      borderRadius: BorderRadius.only( bottomLeft: Radius.circular(15),
    bottomRight: Radius.circular(15),),
  ),
  child:   Padding(
    padding: const EdgeInsets.all(10.0),
    child:   Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        SizedBox(width: 20,),
        Expanded(flex:6,child: Text("Customers",style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),),),
        SizedBox(width: 20,),
        Expanded(flex:2, child:  Container(
            child: Text("Sales", style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),)),),
       // Expanded(flex:2, child:Text("Execution",  style: TextStyle(color: Colors.green[800], fontSize: 15, fontWeight: FontWeight.bold ),)),
    ],),

  ),
),    Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[

                  Expanded(child: datefixedcontainer(title: widget.startDate, isvisible: calender, name: 'Start Date',)),
                  Expanded(child: datefixedcontainer(title: widget.endDate, isvisible: calender, name: 'End Date',)),

                ]),
            Expanded(
              child: FutureBuilder<List>(
                future: customerDataFuture,

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.green,),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child:
                      //Utils.snackBar("message", context)

                      Text('No data available',
                        style: TextStyle(color: Colors.green[800],),),
                    );
                  } else {
                    // Display your ListView with the fetched data
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: storedata.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        storedata.sort((a, b) {
                          String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
                          String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

                          double aSales = double.tryParse(aSalesStr) ?? 0;
                          double bSales = double.tryParse(bSalesStr) ?? 0;

                          // print('aSales: $aSales, bSales: $bSales');

                          return bSales.compareTo(aSales);
                        });
                        final customerData = storedata[index];

                      return
                        Column(
                          children: [
                            if(customerData['Sales_Inc_ST']!=null && ischeck==false )

                            Padding(
                              padding: const EdgeInsets.only(right: 10,left: 10),
                              child: InkWell(
                                  onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CustomerCompanyWise(
                                              empCode: widget.empCode,
                                              startDate: widget.startDate,
                                              endDate: widget.endDate,
                                              customerid: customerData['Customer_BRCUST'].toString(),
                                              customername: customerData['Customer_Cust_Name'],
                                              customerwisename: widget.name, companylist: widget.companylist,
                                              branchlist: widget.branchlist, selectedmeasures: widget.selectedmeasures,
                                            ),
                                          ),
                                        );
                                  },
                                  child:
                                      ProductItem(   empcheck: true,item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Customer_Cust_Name',code:"Customer_BRCUST",
                                        lat: customerData['Customer_Cust_Latt'],
                                        check: true,
                                        long: customerData['Customer_Cust_Long'],
                                        phone: '${customerData['Customer_Cust_Phone']}',
                                      ),


                                  ),
                            ),


                            if(ischeck==true)
                              Padding(
                                padding: const EdgeInsets.only(right: 10,left: 10),
                                child: InkWell(
                                  onTap: (){

                                    // if(customerData.sales!=0)
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomerCompanyWise(
                                          empCode: widget.empCode,
                                          startDate: widget.startDate,
                                          endDate: widget.endDate,
                                          customerid: customerData['Customer_BRCUST'].toString(),
                                          customername: customerData['Customer_Cust_Name'],
                                          customerwisename: widget.name, companylist: widget.companylist,
                                          branchlist: widget.branchlist, selectedmeasures: widget.selectedmeasures,
                                        ),
                                      ),
                                    );
                                  },
                                  child:
                                  ProductItem(    empcheck: true,item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Customer_Cust_Name',code:"Customer_BRCUST",
                                    lat: customerData['Customer_Cust_Latt'],
                                    check: true,
                                    long: customerData['Customer_Cust_Long'],
                                    phone: '${customerData['Customer_Cust_Phone']}',
                                  ),


                                ),
                              ),
                          ],

                        );
                      }

                    );
                  }
                },
              ),
            ),

     calculated_sale(totalsale: NumberFormat('#,###').format(totalSales.round()))
          ],
        ),

    );
  }}
