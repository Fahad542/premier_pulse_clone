import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/utils/customs_widgets/calculated_sale.dart';
import '../../model/company_product_wise.dart';
import '../../respository/company_product_repository.dart';
import '../../utils/customs_widgets/list_filters.dart';
import '../../utils/customs_widgets/text_widget.dart';
import '../../utils/datefixed_containers.dart';
enum SortOptions { Select, byAscendingName, byDecendingName, byMaximumSale, byMinimumSale }
class CustomerProductWise extends StatefulWidget {
  final String empCode;
  final String startDate;
  final String endDate;
  final String customerid;
  final String productid;
  final String name;
  final String sku;
  final List<int>  companylist;
  final List<int>  branchlist;
  late List<String> selectedmeasures;

   CustomerProductWise({
    required this.empCode,
    required this.startDate,
    required this.endDate,
    required this.customerid,
    required this.productid,
    required this.name,
    required this.sku,
    required this.companylist,
    required this.branchlist,
     required this.selectedmeasures,

    Key? key,
  }) : super(key: key);

  @override
  State<CustomerProductWise> createState() => _CustomerWiseState();
}

class _CustomerWiseState extends State<CustomerProductWise> {
  var customerDataFuture;
  double totalSales=0;
  var storedate ;
  String total = '0';
  bool calender = false;
  bool ischeck=false;
  SortOptions selectedSortOption = SortOptions.Select;
  var originalStoredata;
  void _sortData(bool ascending) {

    List<ProductModel> nonEmptyCustomerNameData = storedate
        .where((data) => data.sku.isNotEmpty)
        .toList();

    // Sort the filtered list based on sales
    nonEmptyCustomerNameData.sort((a, b) {
      String aSalesString = a.sales.toString();
      String bSalesString = b.sales.toString();
      double aSales = double.parse(aSalesString.replaceAll(',', '') ?? '0.0');
      double bSales = double.parse(bSalesString.replaceAll(',', '') ?? '0.0');

      if ((aSales == null || aSales == 0) &&
          (bSales == null || bSales == 0)) {
        return 0;
      } else if (aSales == null || aSales == 0) {
        return ascending ? -1 : 1;
      } else if (bSales == null || bSales == 0) {
        return ascending ? 1 : -1;
      }

      return ascending ? aSales.compareTo(bSales) : bSales.compareTo(aSales);
    });

    // Now, update the original storedate list with the sorted data
    for (int i = 0; i < storedate.length; i++) {
      if (storedate[i].sku.isNotEmpty) {
        storedate[i] = nonEmptyCustomerNameData.removeAt(0);
      }
    }
  }

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
                    sortCustomers();
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
                  'Sort by Maximum to Minimum Sale',
                ),
                buildDropdownItem(
                  SortOptions.byMinimumSale,
                  'Sort by Minimum to Maximum Sale',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DropdownMenuItem<SortOptions> buildDropdownItem(SortOptions value,
      String label,) {
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

  void _sortDescendingName() {
    storedate.sort((a, b) {
      if (a.sku.isEmpty && b.sku.isEmpty) {
        return 0; // No change in order if both SKUs are empty
      } else if (a.sku.isEmpty) {
        return 1; // Move items with empty SKU to the end
      } else if (b.sku.isEmpty) {
        return -1; // Move items with empty SKU to the end
      } else {
        return b.sku.compareTo(a.sku);
      }
    });
  }

  void sortCustomers() {
    switch (selectedSortOption) {
      case SortOptions.byAscendingName:
        storedate.sort((a, b) {
          if (a.sku.isEmpty && b.sku.isEmpty) {
            return 0;
          } else if (a.sku.isEmpty) {
            return 1; // Move items with empty SKU to the end
          } else if (b.sku.isEmpty) {
            return -1; // Move items with empty SKU to the end
          } else {
            return a.sku.compareTo(b.sku);
          }
        });
        break;
      case SortOptions.byDecendingName:
        _sortDescendingName();
        break;
      case SortOptions.byMaximumSale:
        _sortData(false);
        break;
      case SortOptions.byMinimumSale:
        _sortData(true);
        break;
      default:
        break;
    }
    print("Sorted data: $storedata");
  }

  var storedata;
    @override
    void initState() {
      super.initState();
      customerDataFuture =
          customer_product_Repository().customer_product_fetchData(
            widget.empCode,
            widget.customerid,
            [widget.productid.toString()],
              widget.branchlist,
            widget.startDate,
            widget.endDate,
            widget.selectedmeasures);
      customerDataFuture.then((data) {
        setState(() {
          storedate = data;
          originalStoredata = List.of(data);
        });
        for (int i = 0; i < storedate.length; i++) {
          if (storedate[i]['Sales_Inc_ST'] != null) {
            totalSales += storedate[i]['Sales_Inc_ST'];
          }
        }
      });
    }

    @override
    Widget build(BuildContext context) {
      // for (int i = 0; i < storedate.length; i++) {
      //
      //     total = storedate[i]['Sales_Inc_ST'].toString();
      //     print("Sku ${i + 1}: ${storedate[i]['Sales_Inc_ST'].toString()}");
      //
      // }
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.sku),
          backgroundColor: Colors.green[800],
          actions: [
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
                if (value == 'Sort') {
                  // Combine the information into a single text message
                  String combinedMessage = ''; // Initialize the combined message outside the loop
                  setState(() {
                    select(context);
                  });

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

              decoration: BoxDecoration(color: Colors.green.shade100,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),),

              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    //SizedBox(width: 10,),
                    Expanded(flex: 4,
                      child: Text(widget.name, style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 14,
                          fontWeight: FontWeight.bold),),),
                    //SizedBox(width: 8,),
                    Expanded(flex: 2, child: Container(
                        child: Text(
                          textAlign: TextAlign.right, "Sales", style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),)),),
                  ],),

              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: datefixedcontainer(title: widget.startDate, isvisible: calender, name: 'Start Date',)),
                  Expanded(child: datefixedcontainer(title: widget.endDate, isvisible: calender, name: 'End Date',)),
                ]),
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

      )],
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
          itemCount: data.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            data.sort((a, b) {
              String aSalesStr = a['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';
              String bSalesStr = b['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0';

              double aSales = double.tryParse(aSalesStr) ?? 0;
              double bSales = double.tryParse(bSalesStr) ?? 0;

              // print('aSales: $aSales, bSales: $bSales');

              return bSales.compareTo(aSales);
            });
            final customerData = data[index];

            return Column(
              children: [
               if (customerData["Sales_Inc_ST"]!=null && ischeck==false)

            Padding(
              padding: const EdgeInsets.only(right: 10,left: 10),
              child:
                ProductItem(   item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Product_Name',code:"",

                ),


              ),


                if (ischeck==true)
                  Padding(
                    padding: const EdgeInsets.only(right: 10,left: 10),
                    child:
                    ProductItem(  item: customerData, selectedmeasures: widget.selectedmeasures, index: index, name: 'Product_Product_Name',code:"",

                    ),


                  ),


              ],
            );
          });
    }
  }
