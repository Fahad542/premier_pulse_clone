import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/model/Company_wise.dart';
import 'package:mvvm/respository/company_wise.dart';
import 'package:mvvm/utils/customs_widgets/calculated_sale.dart';
import 'package:mvvm/utils/customs_widgets/dsf_level_heirarchy.dart';
import '../../utils/customs_widgets/list_filters.dart';
import '../../utils/customs_widgets/text_widget.dart';
import '../../utils/datefixed_containers.dart';
import '../../utils/utils.dart';
import 'company_product.dart';

class company_wise extends StatefulWidget {
  final String empCode;
  final String startDate;
  final String endDate;
  final String name;
  final List<int>  companylist;
  final List<int>  branchlist;
  late List<String> selectedmeasures;

   company_wise(
      {Key? key,
        required this.empCode,
        required this.startDate,
        required this.endDate,
        required this.name,
        required this.companylist,
        required this.branchlist,
        required this.selectedmeasures
       }) :
        super(key: key);

  @override
  State<company_wise> createState() => _customer_wiseState();
}

class _customer_wiseState extends State<company_wise> {

  var storedat;
  int companyid=0;
double totalSales=0;
 bool ischeck=false;
  var customerDataFuture;
  String total='0';
  bool calender=false;
  void _sortData() {
    storedat.sort((a, b) {
      // Check for zero sales
      if (a.sales == null || b.sales == null) return 0;

      // Handle zero sales differently
      if (a.sales == '0' || a.sales==0) {
        return isAscending ? -1 : 1;
      }

      if (b.sales == '0' || b.sales==0) {
        return isAscending ? 1 : -1;
      }

      try {
        // Remove commas and parse as double
        double aSales = double.parse(a.sales.toString().replaceAll(',', '') ?? '0.0');
        double bSales = double.parse(b.sales.toString().replaceAll(',', '') ?? '0.0');
        return isAscending ? aSales.compareTo(bSales) : bSales.compareTo(aSales);
      } catch (e) {
        // Handle the exception, you can print an error message or log it
        print('Error parsing double: $e');
        return 0;
      }
    });
  }



  @override
  void initState() {
    isAscending = false;
    super.initState();
    customerDataFuture = companyRepository().company_wise_fetchData(widget.empCode, widget.startDate, widget.endDate,widget.companylist,
        widget.branchlist, widget.selectedmeasures);
    customerDataFuture.then((data) {
      setState(() {
        storedat = data;
        for(int i=0; i<data.length;i++){
          totalSales+=data[i]['Sales_Inc_ST'];

        }
      });

    });
  }

  bool isAscending = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
      AppBar(
        title: Text(widget.name, style: TextStyle(),),
        backgroundColor: Colors.green[800],
        actions:[

          PopupMenuButton(
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
              if (value == 'date') {
                setState(() {

                  calender = !calender;
                });
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
      ),
      body:

      Column(
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
                  Expanded(flex:6,child: Text("Company",style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),),),
                  Expanded(flex:2, child:  Container(
                      child: Text("Sales", style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),)),),
                  //Expanded(flex:2, child:Text("Execution",  style: TextStyle(color: Colors.green[800], fontSize: 15, fontWeight: FontWeight.bold ),)),
                ],),

            ),
          ),
          Row(
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
                    child: Text(''),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No data available',
                        style: TextStyle(color: Colors.green[800],),
                      ));
                } else {
                  snapshot.data!.sort((a, b) => (b['Sales_Inc_ST'] ?? 0).compareTo(a['Sales_Inc_ST'] ?? 0));
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final companyData = snapshot.data![index];
                        if (companyData['Product_Company_Name']!= null ) {

                        return
                          Column(
                            children: [
                              if(companyData['Sales_Inc_ST']!=null && ischeck==false)
                        //       dsf(
                        //           code:companyData['Product_Company_ID'].toString(),index: index,
                        //         //Execution: '',
                        //         sales: companyData['Sales_Inc_ST'] != null ? NumberFormat('#,###').format(companyData['Sales_Inc_ST']!.round()) : '0'
                        //
                        //
                        //         ,
                        //         title: companyData['Product_Company_Name'].toString(),
                        //         unique_cus: '',
                        //         onTapCallback:(){
                        //           companyid=companyData['Product_Company_ID']!;
                        //       if(companyData['Sales_Inc_ST']!=0)
                        //
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) =>
                        //               Company_Product(
                        //                 empCode: widget.empCode,
                        //                 startDate: widget.startDate,
                        //                 endDate: widget.endDate,
                        //                 companyid: companyData['Product_Company_ID'].toString(),
                        //                 name: companyData['Product_Company_Name'].toString(),
                        //                 company_name: widget.name,
                        //                 companylist: [companyid],
                        //                 branchlist:widget.branchlist, selectedmeasures: widget.selectedmeasures,
                        //               ),
                        //         ),
                        //       );
                        //       else{
                        //
                        //         Utils.flushBarErrorMessage("No Sales Found", context);
                        //       }
                        //
                        // }),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10,left: 10),
                                  child: InkWell(
                                    onTap: (){

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Company_Product(
                                                  empCode: widget.empCode,
                                                  startDate: widget.startDate,
                                                  endDate: widget.endDate,
                                                  companyid: companyData['Product_Company_ID'].toString(),
                                                  name: companyData['Product_Company_Name'].toString(),
                                                  company_name: widget.name,
                                                  companylist: widget.companylist,
                                                  branchlist:widget.branchlist, selectedmeasures: widget.selectedmeasures,
                                                ),
                                          ),
                                        );

                                    },
                                    child:
                                    ProductItem(   empcheck: true,item: companyData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Company_Name',code:"Product_Company_ID",

                                    ),


                                  ),
                                ),

                              if(ischeck==true)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10,left: 10),
                                  child: InkWell(
                                    onTap: (){

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Company_Product(
                                                empCode: widget.empCode,
                                                startDate: widget.startDate,
                                                endDate: widget.endDate,
                                                companyid: companyData['Product_Company_ID'].toString(),
                                                name: companyData['Product_Company_Name'].toString(),
                                                company_name: widget.name,
                                                companylist: [companyid],
                                                branchlist:widget.branchlist, selectedmeasures: widget.selectedmeasures,
                                              ),
                                        ),
                                      );

                                    },
                                    child:
                                    ProductItem(
                                      empcheck: true,
                                      item: companyData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Company_Name',code:"Product_Company_ID",

                                    ),


                                  ),
                                ),
                            ],
                          );

                       }
                        print(snapshot.data![index]);

                        }
    );
                }
              },
            ),
          ),
         calculated_sale(totalsale: NumberFormat('#,###').format(totalSales.round())
         )
        ],
      ),
    );
  }
}
