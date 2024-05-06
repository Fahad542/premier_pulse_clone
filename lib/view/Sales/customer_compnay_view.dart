import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/utils/customs_widgets/calculated_sale.dart';
import '../../respository/customer_company_repositiry.dart';
import '../../utils/customs_widgets/list_filters.dart';
import '../../utils/customs_widgets/text_widget.dart';
import '../../utils/datefixed_containers.dart';
import '../../utils/utils.dart';
import 'customer_product.dart';

class CustomerCompanyWise extends StatefulWidget {
  final String empCode;
  final String startDate;
  final String endDate;
  final String customerid;
final String customername;
final String customerwisename;
  final List<int>  companylist;
  final List<int>  branchlist;
  late List<String> selectedmeasures;
   CustomerCompanyWise({
    required this.empCode,
    required this.startDate,
    required this.endDate,
    required this.customerid,
    required this.companylist,
    required this.branchlist,
    required this.customername,
    required this.customerwisename,
    required this.selectedmeasures,
     Key? key,
  }) : super(key: key);

  @override
  State<CustomerCompanyWise> createState() => _CustomerWiseState();
}

class _CustomerWiseState extends State<CustomerCompanyWise> {
  var customerDataFuture;
 var storedate;
  String total='0';
  int companyId=0;
  double totalSales=0.0;
  bool calender=false;
  bool ischeck=false;
  @override
  void initState() {
    super.initState();
    customerDataFuture = customer_company_Repository().customer_company_fetchData(
      widget.empCode.toString(),
      widget.customerid.toString(),
      widget.startDate,
      widget.endDate,
      widget.companylist,
      widget.branchlist,widget.selectedmeasures
    );
    customerDataFuture.then((data) {
      setState(() {
        storedate = data;

      });

        for (int i = 0; i < storedate.length; i++) {
          if (storedate[i]['Sales_Inc_ST'] != null) {
            totalSales += storedate[i]['Sales_Inc_ST'];
          }
        }
print("storedate$storedate");


    });


    }


  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < storedate.length; i++) {
    //   if(storedate[i]['Sales Inc ST']!=null){
    //     total +=storedate[i]['Sales Inc ST'].toString();
    //   }
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customername, style: TextStyle(),),
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
                // PopupMenuItem(
                //   child: Row(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.all(6),
                //         decoration: BoxDecoration(
                //           color: Colors.green[800],
                //           borderRadius: BorderRadius.circular(6),
                //         ),
                //         child: Icon(Icons.filter_list, color: Colors.white, size: 18),
                //       ),
                //       SizedBox(width: 6),
                //       Text('Measures', style: TextStyle(fontSize: 14)),
                //       SizedBox(width: 6),
                //
                //     ],
                //   ),
                //   value: 'Measures',
                // ),
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
                  Expanded(flex:6,child: Text("Company",style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),),),
                  SizedBox(width: 20,),
                  Expanded(flex:2, child:  Container(
                      child: Text("Sales", style: TextStyle(color: Colors.green[800], fontSize: 16, fontWeight: FontWeight.bold ),)),),
                 // Expanded(flex:2, child:Text("Execution",  style: TextStyle(color: Colors.green[800], fontSize: 15, fontWeight: FontWeight.bold ),)),
                ],),

            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Expanded(child: datefixedcontainer(title: widget.startDate, isvisible: calender, name: 'Start Date',)),
                Expanded(child: datefixedcontainer(title: widget.endDate, isvisible: calender, name: 'End Date',)),
              ]),
          //heading_container(title: widget.customername ,),
          Expanded(
            child: FutureBuilder<List>(
              future: customerDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingWidget();
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildNoDataWidget();
                } else {
                  return _buildListView(snapshot.data!);
                }
              },
            ),
          ),

          calculated_sale(totalsale: NumberFormat('#,###').format(totalSales.round())
          ) ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(color: Colors.green),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Text(
        'No data available',
        style: TextStyle(color: Colors.green[800]),
      ),
    );
  }

  Widget _buildListView(List data) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: storedate?.length ??0,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        storedate.sort((a, b) {
          String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
          String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

          double aSales = double.tryParse(aSalesStr) ?? 0;
          double bSales = double.tryParse(bSalesStr) ?? 0;

          // print('aSales: $aSales, bSales: $bSales');

          return bSales.compareTo(aSales);
        });
    final customerData = data[index];
    return
    Column(
    children: [
    if (customerData['Sales_Inc_ST'] != null && ischeck==false )

      Padding(
        padding: const EdgeInsets.only(right: 10,left: 10),
        child: InkWell(
          onTap: (){

            // if(customerData.sales!=0)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerProductWise(
                    empCode: widget.empCode,
                    startDate: widget.startDate,
                    endDate: widget.endDate,
                    customerid: widget.customerid,
                    productid:customerData["Product_Company_ID"].toString(),
                    name: customerData["Product_Company_Name"].toString(),
                    sku: widget.customername,
                    branchlist: widget.branchlist,
                    companylist: widget.companylist,
                    selectedmeasures: widget.selectedmeasures,


                  )
              ),
            );
          },
          child:
          ProductItem(   empcheck: true,item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Company_Name',code:"Product_Company_ID",

          ),


        ),
      ),
      if ( ischeck==true )

        Padding(
          padding: const EdgeInsets.only(right: 10,left: 10),
          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerProductWise(
                      empCode: widget.empCode,
                      startDate: widget.startDate,
                      endDate: widget.endDate,
                      customerid: widget.customerid,
                      productid:customerData["Product_Company_ID"].toString(),
                      name: customerData["Product_Company_Name"].toString(),
                      sku: widget.customername,
                      branchlist: widget.branchlist,
                      companylist: widget.companylist,
                      selectedmeasures: widget.selectedmeasures,
                    )
                ),
              );
            },
            child:
            ProductItem(    empcheck: true,item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Company_Name',code:"Product_Company_ID",

            ),


          ),
        ),
    ],

    );
    });}}